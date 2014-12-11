﻿using System;
using System.Linq;
using NHibernate;
using Seedworks.Lib.Persistence;
using TrueOrFalse.Maintenance;

namespace TrueOrFalse
{
    public class ImageMetaDataRepository : RepositoryDb<ImageMetaData>
    {
        public ImageMetaDataRepository(ISession session) : base(session){}

        public ImageMetaData GetBy(int typeId, ImageType imageType)
        {
            return _session.QueryOver<ImageMetaData>()
                           .Where(x => x.TypeId == typeId)
                           .And(x => x.Type == imageType)
                           .SingleOrDefault<ImageMetaData>();
        }
        
        public void StoreSetUploaded(int questionSetId, int userId, string licenseGiverName){
            StoreUploaded(questionSetId, userId, ImageType.QuestionSet, licenseGiverName);
        }

        public void StoreWiki(
            int typeId, 
            ImageType imageType, 
            int userId, 
            WikiImageMeta wikiMetaData)
        {
            var imageMeta = GetBy(typeId, imageType);
            if (imageMeta == null)
            {   
                var newImageMetaData = new ImageMetaData
                {
                    Type = imageType,
                    TypeId = typeId,
                    ApiHost = wikiMetaData.ApiHost,
                    Source = ImageSource.WikiMedia,
                    SourceUrl = wikiMetaData.ImageUrl,
                    ApiResult = wikiMetaData.JSonResult,
                    UserId = userId,
                };

                ServiceLocator.Resolve<LoadImageMarkups>().Run(newImageMetaData);
                SetAllParsedLicenses(newImageMetaData);

                Create(newImageMetaData);
            }
            else
            {
                //$temp: warum hier kein ApiHost?
                imageMeta.Source = ImageSource.WikiMedia;
                imageMeta.SourceUrl = wikiMetaData.ImageUrl;
                imageMeta.ApiResult = wikiMetaData.JSonResult;
                imageMeta.UserId = userId;

                ServiceLocator.Resolve<LoadImageMarkups>().Run(imageMeta);
               
                SetAllParsedLicenses(imageMeta);

                Update(imageMeta);
            }
        }

        public static void SetMainLicenseInfo(ImageMetaData imageMetaData, int MainLicenseId)
        {
            if (imageMetaData == null) return;
            if (LicenseRepository.GetAllAuthorizedLicenses().All(x => x.Id != MainLicenseId)) return;
            if (!LicenseParser.CheckLicenseRequirements(LicenseRepository.GetById(MainLicenseId), imageMetaData).AllRequirementsMet) return;
            var manualEntries = imageMetaData.ManualEntriesFromJson();
            var mainLicenseInfo = new MainLicenseInfo
            {
                MainLicenseId = MainLicenseId,
                Author = !String.IsNullOrEmpty(manualEntries.AuthorManuallyAdded) ?
                    manualEntries.AuthorManuallyAdded :
                    imageMetaData.AuthorParsed,
                Markup = imageMetaData.Markup,
                MarkupDownloadDate = imageMetaData.MarkupDownloadDate,
            };
            imageMetaData.MainLicenseInfo = mainLicenseInfo.ToJson();
        }

        public static void SetAllParsedLicenses(ImageMetaData imageMeta)
        {
            imageMeta.AllRegisteredLicenses =
                   License.ToLicenseIdList(
                       LicenseParser.ParseAllRegisteredLicenses(imageMeta));
        }

        private void StoreUploaded(int typeId, int userId, ImageType imageType, string licenseGiverName)
        {
            var imageMeta = GetBy(typeId, imageType);
            if (imageMeta == null)
            {
                Create(
                    new ImageMetaData
                    {
                        TypeId = typeId,
                        Type = imageType,
                        Source = ImageSource.User,
                        ApiResult = licenseGiverName,
                        UserId = userId
                    }
                );
            }
            else
            {
                imageMeta.Source = ImageSource.User;
                imageMeta.UserId = userId;
                imageMeta.ApiResult = licenseGiverName;

                Update(imageMeta);
            }                        
        }
    }
}
