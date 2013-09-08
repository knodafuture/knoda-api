using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.IO;
using System.Text;

using PushSharp;
using PushSharp.Apple;
using PushSharp.Core;

namespace PushSharp.Sample
{
	class Program
	{
		const string certPassword = "111";
		const bool isProduction = true;

		static int Main(string[] args)
		{	
			// check for the first argument
			if (args.Length < 1) {
				Console.Write ("Error: Please specify input file\n");
				return 1;
			}

			//Create our push services broker
			var push = new PushBroker();

			//Wire up the events for all the services that the broker registers
			push.OnNotificationSent += NotificationSent;
			push.OnChannelException += ChannelException;
			push.OnServiceException += ServiceException;
			push.OnNotificationFailed += NotificationFailed;
			push.OnDeviceSubscriptionExpired += DeviceSubscriptionExpired;
			push.OnChannelCreated += ChannelCreated;
			push.OnChannelDestroyed += ChannelDestroyed;

			//------------------------------------------------
			//IMPORTANT NOTE about Push Service Registrations
			//------------------------------------------------
			//Some of the methods in this sample such as 'RegisterAppleServices' depend on you referencing the correct
			//assemblies, and having the correct 'using PushSharp;' in your file since they are extension methods!!!

			// If you don't want to use the extension method helpers you can register a service like this:
			//push.RegisterService<WindowsPhoneToastNotification>(new WindowsPhonePushService());

			//If you register your services like this, you must register the service for each type of notification
			//you want it to handle.  In the case of WindowsPhone, there are several notification types!

			//-------------------------
			// APPLE NOTIFICATIONS
			//-------------------------
			//Configure and start Apple APNS
			// IMPORTANT: Make sure you use the right Push certificate.  Apple allows you to generate one for connecting to Sandbox,
			//   and one for connecting to Production.  You must use the right one, to match the provisioning profile you build your
			//   app with!
			var appleCert = File.ReadAllBytes(Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "./certificate.p12"));
			//IMPORTANT: If you are using a Development provisioning Profile, you must use the Sandbox push notification server 
			//  (so you would leave the first arg in the ctor of ApplePushChannelSettings as 'false')
			//  If you are using an AdHoc or AppStore provisioning profile, you must use the Production push notification server
			//  (so you would change the first arg in the ctor of ApplePushChannelSettings to 'true')
			push.RegisterAppleService(new ApplePushChannelSettings(isProduction, appleCert, certPassword)); //Extension method
			//Fluent construction of an iOS notification
			//IMPORTANT: For iOS you MUST MUST MUST use your own DeviceToken here that gets generated within your iOS app itself when the Application Delegate
			//  for registered for remote notifications is called, and the device token is passed back to you

			Debug ("Reading messages from input file");

			System.IO.StreamReader file = new System.IO.StreamReader(args[0]);
			string line;
			while ((line = file.ReadLine()) != null) {
				string[] words = line.Split (' ');

				string token = words [0];
				int predictions = Convert.ToInt32 (words [1]);
				int badges = Convert.ToInt32 (words [2]);

				push.QueueNotification(new AppleNotification()
				                       .ForDeviceToken(token)
				                       .WithAlert(getMessageByPredictionsCount(predictions))
				                       .WithBadge(badges)
				                       .WithSound("siren.aiff"));
			}

			Debug("Waiting for Queue to Finish...");

			//Stop and wait for the queues to drains
			push.StopAllServices();
			return 0;
		}

		static string getMessageByPredictionsCount(int predictionsCount) {
			if (predictionsCount == 1) {
				return "You have one new expired prediction";
			}
			else {
				return string.Format ("You have {0} new expired predictions", predictionsCount);
			}
		}

		static void Debug(String s)
		{
			Console.Error.WriteLine (String.Format("-> {0}", s));
		}

		static void NotificationSent(object sender, INotification notification)
		{
			Debug("Sent: " + sender + " -> " + notification);
		}

		static void NotificationFailed(object sender, INotification notification, Exception notificationFailureException)
		{
			Debug("Failure: " + sender + " -> " + notificationFailureException.Message + " -> " + notification);

			if (notification is AppleNotification) {
				Console.WriteLine (((AppleNotification)notification).DeviceToken);
			}
		}

		static void DeviceSubscriptionExpired(object sender, string expiredDeviceSubscriptionId, DateTime timestamp, INotification notification)
		{
			Debug("Device Subscription Expired: " + sender + " -> " + expiredDeviceSubscriptionId);
			Console.WriteLine (expiredDeviceSubscriptionId);
		}

		static void ChannelException(object sender, IPushChannel channel, Exception exception)
		{
			Debug("Channel Exception: " + sender + " -> " + exception);
		}

		static void ServiceException(object sender, Exception exception)
		{
			Debug("Channel Exception: " + sender + " -> " + exception);
		}

		static void ChannelDestroyed(object sender)
		{
			Debug("Channel Destroyed for: " + sender);
		}

		static void ChannelCreated(object sender, IPushChannel pushChannel)
		{
			Debug("Channel Created for: " + sender);
		}
	}
}
