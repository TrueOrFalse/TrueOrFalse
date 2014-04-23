﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using NUnit.Framework;
using TrueOrFalse.Tests;
using TrueOrFalse.WikiMarkup;


namespace TrueOrFalse.Tests._2_Domain.Image
{
    class ImageLicenceInfo_from_wikimedia : BaseTest
    {
        [Ignore]//tmp
        [Test]
        public void Get_licence_info()
        {
            var licenceInfoLoader = Resolve<WikiImageLicenceLoader>();
            var licenceInfo = licenceInfoLoader.Run("Platichthys_flesus_Vääna-Jõesuu_in_Estonia.jpg");
            Assert.That(licenceInfo.Attribution, 
                Is.EqualTo("By Tiit Hunt (Own work) [CC-BY-SA-3.0 (http://creativecommons.org/licenses/by-sa/3.0)], via Wikimedia Commons"));

        }

        [Test]
        public void Should_parse_markup_of_image_details_page()
        {
            const string demoText = @"
                {{Information
                |Description    = {{mld
                | cs = [[:cs:Platýs bradavičnatý|Platýs bradavičnatý]] blízko estonské vesnice Vääna Jöesuu
                | de = Eine [[:de:Flunder|Flunder]], ''Platichthys flesus'', nahe dem estnischen Dorf [[:de:Vääna-Jõesuu|Vääna-Jõesuu]]
                | en = ''{{W|European flounder|Platichthys flesus}}'' near {{W|Vääna-Jõesuu}} in [[:w:Estonia|Estonia]].
                | et = Vääna-Jõesuu rannikumere lest
                | fr = Flet commun, ''Platichthys flesus'', près de Vääna-Jöesuu en [[:Estonie|Estonie]].
                | pt = [[:pt:Linguado|Linguado]], ''Platichthys flesus'', nas proximidades de {{W|Vääna-Jõesuu}} na [[:w:Estonia|Estônia]].
                }}
                |Date           = 2010-01-06
                |Source         = {{own}}
                |Author         = [[User:Tiithunt|Tiit Hunt]]
                |Permission     = 
                |Other versions = 
                |Other fields   = 
                }}
                {{HELP 2011}}
                {{Assessments|featured=1|com-nom=Lest.jpg}}
                {{picture of the day|year=2013|month=02|day=18}}
                {{QualityImage}}

                =={{int:license-header}}==
                {{self|cc-by-sa-3.0}}

                [[Category:Platichthys flesus]]
                [[Category:Fish of Estonia]]
                [[Category:Vääna-Jõesuu]]
                [[Category:Unassessed QI candidates]]
                [[Category:Featured pictures of Estonia]]
                [[Category:Featured pictures supported by Wikimedia Eesti]]
                [[Category:Taken with Canon EOS 5D Mark II]]
                [[Category:Quality images of animals in Estonia]]
                [[Category:Uploaded with UploadWizard]]";


            var parsedImageMakup = ParseImageMarkup.Run(demoText);
            var infoSectionParams = parsedImageMakup.InfoTemplate.Parameters;

            Assert.That(infoSectionParams.Count, Is.EqualTo(6));
            Assert.That(infoSectionParams[0].Key, Is.EqualTo("Description"));
            Assert.That(infoSectionParams[1].Key, Is.EqualTo("Date"));
            Assert.That(infoSectionParams[1].Value, Is.EqualTo("2010-01-06"));

            Assert.That(parsedImageMakup.DescriptionDE_Raw, 
                Is.EqualTo("Eine [[:de:Flunder|Flunder]], ''Platichthys flesus'', nahe dem estnischen Dorf [[:de:Vääna-Jõesuu|Vääna-Jõesuu]]"));

        }
    }
}
