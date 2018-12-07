using System;
using System.Windows;
using System.Windows.Controls;
using System.Diagnostics;

namespace TWCLauncher
{
    public partial class ManualWin : Window
    {
        private string servertext;

        public ManualWin()
        {
            InitializeComponent();
        }

        private void IPInput_TextChanged(object sender, TextChangedEventArgs e)
        {
            TextBox txt = (TextBox)sender;
            servertext = txt.Text;
        }

        private void Button_Click(object sender, RoutedEventArgs e)
        {
            Process.Start("byondfiles\\dreamseeker.exe", servertext);
        }
    }
}
