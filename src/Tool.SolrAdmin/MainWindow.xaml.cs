﻿using System;
using System.Windows;
using System.Windows.Threading;
using TrueOrFalse.Updates;

namespace Tool.SolrAdmin
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        public MainWindow()
        {
            InitializeComponent();

            var settings = SettingsRepo.Load();

            txtPathToSolr.Text = settings.SolrPath;
            txtUrlToSolr.Text = settings.SolrUrl;

            lblMessage.Visibility = Visibility.Hidden;

            SetSolrSettings();

            SolrCoreReload.Message += (sender, message) => WriteLog(message);
        }

        private void btnSave_Click(object sender, RoutedEventArgs e)
        {
            var settings = new Settings{
                SolrPath = txtPathToSolr.Text, 
                SolrUrl = txtUrlToSolr.Text
            };

            SettingsRepo.Save(settings);

            SetMessage("Wurde gespeichert");
            SetSolrSettings();
        }

        private void SetMessage(string message)
        {
            lblMessage.Visibility = Visibility.Visible;
            lblMessage.Content = message;

            var dispatcherTimer = new DispatcherTimer();
            dispatcherTimer.Interval = new TimeSpan(0, 0, 0, 3);
            dispatcherTimer.Start();

            dispatcherTimer.Tick += delegate
            {
                lblMessage.Visibility = Visibility.Hidden;
                dispatcherTimer.Stop();
            };
        }

        private void SetSolrSettings()
        {
            var settings = SettingsRepo.Load();
            if (string.IsNullOrEmpty(settings.SolrPath) || string.IsNullOrEmpty(settings.SolrPath))
                return; 

            SolrCoreReload.Set(settings.SolrUrl, settings.SolrPath);
        }

        private void btnCopySchemas_OnClick(object sender, RoutedEventArgs e)
        {
            SolrCoreReload.ReloadAllSchemas();
            SetMessage("LIVE: Schemas wurden kopiert");
        }

        private void btnCopyConfigs_OnClick(object sender, RoutedEventArgs e)
        {
            SolrCoreReload.ReloadAllConfigs();
            SetMessage("LIVE: Configs wurden kopiert");
        }

        private void btnCopySchemasTests_OnClick(object sender, RoutedEventArgs e)
        {
            SolrCoreReload.ReloadAllSchemas(testSchemas: true);
            SetMessage("TESTs: Schemas wurden kopiert");
        }

        private void btnCopyConfigsTests_OnClick(object sender, RoutedEventArgs e)
        {
            SolrCoreReload.ReloadAllConfigs(testSchemas: true);
            SetMessage("TESTs: Configs wurden kopiert");
        }

        private void WriteLog(string log)
        {
            Dispatcher.Invoke(() =>
            {
                txtLog.Text =
                    "[" + DateTime.Now.ToString("HH:mm:ss") + "] " +
                    log +
                    Environment.NewLine +
                    txtLog.Text;
            });
        }
    }
}