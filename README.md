# Azure Event Hub Tester Script
A Powershell Script to quickly test if your Event Hub and its settings are functional

This script will send your computer information to the event hub as a test. The information will containe your Windows computer information name, in this format:

{'DeviceId':'MITSEDP-929999', 'Make':'Micro-Star_International_Co.__Ltd.', 'Model':'GS66_Stealth_10SF', 'OS':'Microsoft_Windows_11_Business', 'User':'AzureAD\SenaGangbe', 'Timestamp':'2022-04-09T21:31:54'}

# 1. Edit the script with your event hub information

$eventHubsRessourceFQDN = "eventhub resource FQDN"
  
$eventHubName = "evemt hub name"
  
$Access_Policy_Name="SAS Policy Name. Default : RootManageSharedAccessKey" #default value
  
$Access_Policy_Key="SAS Key"
  
  
An Event Hubs domain name looks like : marlongroup214323.servicebus.windows.net
  
An Event Hub name looks like: aneventhub213
  
Access Policies can be specific to your Event Hub or your Event Hub Ressource. By default, it is specifix to the Event Hub Ressource, thus can be used to access any Event Hub hosted in it.

# 2. Run the script and monitor your event hub for traffic

You can also simply use the monitoring tools in the Event Hub, although this is only quantitative feed back.
We currently see there is nothing happening
 
![image](https://user-images.githubusercontent.com/84939562/162597764-5ed72346-5138-4d1c-81b9-ee2c2a5189d4.png)
  
 After running the script multiple times, we can see some new traffic. 
 We see the sharp increase in messages continuously triggering the event hub. Our testing method is successful!
  
![image](https://user-images.githubusercontent.com/84939562/162597777-5a22fae7-3442-4411-8279-cefc3458965d.png)

# 3. (Optional) Read events in your Event Hub in real-time
  
You can use “process data” to get some real time insight into the content being sent, or you may use a simple listener application. The preview of process data is very sensitive to what can be send before completely failing (ex: an extra comma that breaks json format), thus I recommend using a monitoring app. This app is a simple app that reads event.
  
 ![image](https://user-images.githubusercontent.com/84939562/162597803-6f3aeb1e-6b11-4553-85dc-c26036959265.png)

 What it looks like with multiple triggers of the powershell script appearing in real-time
  
  ![image](https://user-images.githubusercontent.com/84939562/162597811-05e79a2d-7fd8-4b20-a6c0-b30e5ebf780e.png)
