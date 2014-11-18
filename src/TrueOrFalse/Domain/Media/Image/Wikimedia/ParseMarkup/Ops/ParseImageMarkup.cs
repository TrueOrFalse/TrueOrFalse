﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Security.Cryptography;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using System.Web.UI;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using NHibernate.Impl;
using SolrNet.Mapping.Validation;

namespace TrueOrFalse.WikiMarkup
{
    public class ParseImageMarkup
    {
        public static ParseImageMarkupResult Run(string markup)
        {
            var result = new ParseImageMarkupResult();
            var templateFound = false;
            foreach (var infoBoxTemplate in InfoBoxTemplate.GetAllInfoBoxTemplates())
            {
                if (ParseTemplate.GetTemplateByName(markup, infoBoxTemplate.TemplateName).IsSet)
                {
                    result.InfoTemplate = ParseTemplate.GetTemplateByName(markup, infoBoxTemplate.TemplateName);
                    result.InfoBoxTemplate = infoBoxTemplate;
                    templateFound = true;
                    break;
                }
            };

            if (templateFound) {
                Care_about_description_and_author(result);
                Care_about_license_template(markup, result);
            }

            return result;
        }

        private static void Care_about_license_template(string markup, ParseImageMarkupResult result)
        {
            //http://en.wikipedia.org/wiki/Template:Self
            var selfTemplate = ParseTemplate.GetTemplateByName(markup, "self");
            if (selfTemplate.IsSet)
            {
                var allLicenseTemplates = selfTemplate.Parameters.Where(x => !x.HasKey).ToList();

                Func<Parameter, string, bool> fnPredicate = (x, startsWith) => x.Value.ToLower().StartsWith(startsWith);
                if (allLicenseTemplates.Any(x => fnPredicate(x, "pd")))
                {
                    result.LicenseIsPublicDomain = true;
                    result.LicenseTemplateString = allLicenseTemplates.First(x => fnPredicate(x, "pd")).Value;
                }
                else if (allLicenseTemplates.Any(x => fnPredicate(x, "gfdl")))
                {
                    result.LicenseIsGFDL = true;
                    result.LicenseTemplateString = allLicenseTemplates.First(x => fnPredicate(x, "gfdl")).Value;
                }
                else if (allLicenseTemplates.Any(x => fnPredicate(x, "cc-")))
                {
                    result.LicenseIsCreativeCommons = true;
                    result.LicenseTemplateString = allLicenseTemplates.First(x => fnPredicate(x, "cc-")).Value;
                }
            }            
        }

        private static void Care_about_description_and_author(ParseImageMarkupResult result)
        {
            var paramDesc = result.InfoTemplate.ParamByKey(result.InfoBoxTemplate.DescriptionParamaterName);
            if (paramDesc != null)
                SetDescription(result, paramDesc);

            var paramAuthor = result.InfoTemplate.ParamByKey(result.InfoBoxTemplate.AuthorParameterName);
            if (paramAuthor != null)
                SetAuthor(result, paramAuthor);
        }

        private static void SetDescription(ParseImageMarkupResult result, Parameter descrParameter)
        {
            var preferredLanguages = new List<string>
            {
                //Markup is parsed for description in the following languages (ordered by priority)
                "de", "en", "fr", "es", "ca", "ru", "hu"
            };

            var i = 0;
            var paramValue = "";
            var mldSection = ParseTemplate.GetTemplateByName(descrParameter.Value, "Multilingual description").IsSet ?
                ParseTemplate.GetTemplateByName(descrParameter.Value, "Multilingual description") :
                ParseTemplate.GetTemplateByName(descrParameter.Value, "mld");

            while (i < preferredLanguages.Count()) {

                //Parse for "multilingual description"/"mld"


                //Check for description in preferred languages (ordered by priority) in "multilingual description"/"mld"
                if (mldSection.Parameters.Any(x => x.Key == preferredLanguages[i]))
                {
                    paramValue = mldSection.ParamByKey(preferredLanguages[i]).Value;
                    break;
                }

                //Check for preferred languages in seperate description templates
                var langSection = ParseTemplate.GetTemplateByName(descrParameter.Value, preferredLanguages[i]);
                if(langSection.IsSet)
                {
                    if (langSection.Parameters.Any())
                    {
                        paramValue = langSection.Parameters.First().Value;
                        break;
                    }
                }

                i++;
            }

            //If no description in preferred languages is found, search for descriptions in other languages and take the first of them
            if (String.IsNullOrEmpty(paramValue))
            {
                //Search in "multilingual description"/"mld"
                if (mldSection.Parameters.Any())
                {
                    paramValue = mldSection.Parameters.First().Value;
                }
                //Search in seperate description templates
                else if (GetDescriptionInAllAvailableLanguages(descrParameter.Value).Any())
                {
                    paramValue = GetDescriptionInAllAvailableLanguages(descrParameter.Value).Select(d => d.Raw).First();
                }
            }

            if (!String.IsNullOrEmpty(paramValue)) { 
                result.Description_Raw = paramValue;
                result.Description = Markup2Html.TransformAll(paramValue);
            } 
            else if (!String.IsNullOrEmpty(descrParameter.Value)
                       && !descrParameter.Value.Contains("{{")
                       && !descrParameter.Value.Contains("}}"))
            {
                //If description doesn't contain any templates, just plain text
                result.Description_Raw = descrParameter.Value;
                result.Description = Markup2Html.TransformAll(descrParameter.Value);
            }
        }

        private static void SetAuthor(ParseImageMarkupResult result, Parameter paramAuthor)
        {
            //$temp: Cases left to match:

            //[[:en:William Simpson (artist)|William Simpson]]<br/>Published by Paul & Dominic Colnaghi & Co. --> William Simpson<br/>Published by Paul & Dominic Colnaghi & Co.
            //war bisher abgedeckt durch Markup2Html.Run

            //Mehrteilig:
            //http://commons.wikimedia.org/wiki/File:13-01-15-leipzig-hauptbahnhof-by-RalfR-33.jpg
            //|Author=[[User:Ralf Roletschek|Ralf Roletschek]] ([[User talk:Ralf Roletschek|<span class="signature-talk">talk</span>]]) - [http://www.fahrradmonteur.de Infos über Fahrräder auf fahrradmonteur.de]
            //Gerendert: Ralf Roletschek (talk) - Infos über Fahrräder auf fahrradmonteur.de (mit Links auf User, talk und link)
            //Use this file > attribution: By Ralf Roletschek (talk) - Infos über Fahrräder auf fahrradmonteur.de (Own work) [GFDL (http://www.gnu.org/copyleft/fdl.html) or CC-BY-SA-3.0-2.5-2.0-1.0 (http://creativecommons.org/licenses/by-sa/3.0)], via Wikimedia Commons

            //spezielle Attribution templates (nicht am Author erkennbar, nur unter Licenses)
            //...
            //|Author={{User:Noaa/Author}}
            //...
            //== {{int:license}} ==
            //{{self|User:Noaa/AttributionTemplate}}
            //Template can be found here: http://commons.wikimedia.org/wiki/User:Noaa/AttributionTemplate

//          Link unter Autor sollte vielleicht nicht einfach verschwinden
            //https://commons.wikimedia.org/wiki/File:Cavalryatbalaklava2.jpg
            //|Author=[[:en:William Simpson (artist)|William Simpson]]<br/>Published by Paul & Dominic Colnaghi & Co.

            //Erweitert mit Text
            //http://commons.wikimedia.org/wiki/File:Friedhof_G%C3%BCstebieser_Loose_15.JPG
            //|Author=Picture taken by [[User:Marcus Cyron|Marcus Cyron]]

            //$temp:
            //Message setzen, wenn paramAuthor == null

            if (paramAuthor != null)
            {
                var authorText = Markup2Html.TransformAll(paramAuthor.Value);

                //Templates of type "{{User:XRay/Templates/Author}}" (user custom templates), match "User:XRay/Templates/Author"
                //http://commons.wikimedia.org/wiki/File:Unho%C5%A1%C5%A5,_hlavn%C3%AD_t%C5%99%C3%ADda.JPG
                //|Author={{User:Aktron/Author2}}
                //Link to template: http://commons.wikimedia.org/wiki/User:Aktron/Author2


                var parseImageNotifications = ParseImageNotifications.FromJson(result.Notifications);

                var regexMatch_UserAttributionTemplate = Regex.Match(authorText, "{{(User:\\w*/.*)}}");
                if (regexMatch_UserAttributionTemplate.Success)
                {
                    parseImageNotifications.Author.Add(new Notification()
                    {
                        Name = "asdsaf",
                        NotificationText = String.Format(
                            "-Benutzerdefiniertes Template: Bitte aus Template \"{0}\" gerenderten Text als Autor von der Bilddetailsseite oder unter <a href=\"{1}\">{1}</a> manuell übernehmen.-",
                            regexMatch_UserAttributionTemplate.Groups[0],
                            "http://commons.wikimedia.org/wiki/" + regexMatch_UserAttributionTemplate.Groups[1])
                    });
                    
                    result.Notifications = parseImageNotifications.ToJson();
                    return;
                }
                if (CheckForMarkupSyntaxContained(authorText))
                {
                    parseImageNotifications.Author.Add(new Notification()
                    {
                        Name = "adsfasfa",
                        NotificationText =
                            String.Format(
                                "-Das Markup für den Autor konnte nicht (vollständig) automatisch geparsed werden (es ergab sich: \"{0}\"). Bitte Angaben für den Autor manuell übernehmen.-",
                                authorText)
                    });

                    result.Notifications = parseImageNotifications.ToJson();
                    return;
                }

                result.AuthorName_Raw = paramAuthor.Value;
                result.AuthorName = authorText;
            }
        }

        public static bool CheckForMarkupSyntaxContained(string text)
        {
            return Regex.IsMatch(text, "[{}\\[\\]]"); //Check for "{", "}", "[" or "]"
        }

        public static List<Template> GetDescriptionInAllAvailableLanguages(string dscrTemplate)
        {
            return ParseTemplate.GetAllMatchingTemplates(dscrTemplate, WikiLanguage.GetAllLanguages().Select(l => l.LanguageToken).ToList());
        }
    }
}
