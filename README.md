# Use Case 1:
1) Create a lwc (lightning web component) that takes zip code as an input and makes an
api call. You can use the free zip code api (http://api.zippopotam.us/us/<zipcode>).
2) If the country in response is “US”, response should be shown in another lightning
component (No need to save data) but if the country value is anything else, response
should be stored in a custom object.
3) Use api url dynamically e.g. if country is Mexico, use http://api.zippopotam.us/MX/01000
4) We should be able to see the non-US data in a different screen.

# Solution :- 
Metadata Components 
# Parent LWC Created 
- LWC  : zipcodeLookup (Main LWC where user can enter Zip code and search along with country selection )
- ApexClass: ZipCodeController (contains apex actions for callouts and logging non US response)
- ApexClass: ZipCodeCalloutResponseParser (JSON Parser class for response parsing)

# Child LWC componens 
- LWC : showNonUSData
- LWC : zipCodeResponse

<img width="1164" alt="Screenshot 2024-08-05 at 4 04 24 AM" src="https://github.com/user-attachments/assets/8bc710f7-85cb-408b-9d4a-87d60c447813">

# When Zip Code search is done for any Other country other than US 
<img width="1127" alt="Screenshot 2024-08-05 at 4 05 24 AM" src="https://github.com/user-attachments/assets/8ca25753-c0f6-46db-b7a0-c856a91c8e86">

# When Zip Code search is done for US Country 
<img width="940" alt="Screenshot 2024-08-05 at 4 06 59 AM" src="https://github.com/user-attachments/assets/9742d28d-be62-460b-80b9-a50e640f703f">

# If No data is Found
<img width="1033" alt="Screenshot 2024-08-05 at 4 07 17 AM" src="https://github.com/user-attachments/assets/dfdc2f49-bcf0-49c4-afc7-cacbca922c57">


# 5) Achieve the same using flow with proper exception handling. For this create a separate UI experience.
# Solution 
Created a Flow which provides the same functionality for Postal Code search 
- Flow: Zip_Explorer_Flow.flow-meta.xml  
- Named Credentials :- ZipCodeSearch
- External Service :- zippopotam_us
  
<img width="1440" alt="Screenshot 2024-08-05 at 4 11 58 AM" src="https://github.com/user-attachments/assets/39577e3a-fae3-4c58-acad-35e91ce05212">

# Zip Code search for Non - US , where logging needs to be done and details to shown
<img width="1440" alt="Screenshot 2024-08-05 at 4 12 15 AM" src="https://github.com/user-attachments/assets/f2ce20ca-2689-47c7-9d16-0ae3df1546d7">

# Zip Code search for US 
<img width="1439" alt="Screenshot 2024-08-05 at 4 12 40 AM" src="https://github.com/user-attachments/assets/67dcc3aa-602a-47a9-a07b-75ef824a16ad">

# In Case no response found for Search
<img width="1439" alt="Screenshot 2024-08-05 at 4 13 08 AM" src="https://github.com/user-attachments/assets/af7fc113-2cd6-4f4d-bab9-857fd87d7c49">

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# Use Case 2:
1) Create a custom field called “Risk” with values as High, Low, Medium.
2) When the value “High” is selected, trigger a platform event.
3) Platform event should be subscribed, and case should be created. Case Owner should be
a user different than account owner.

# Solution
**Metadata Components **
- Custom Platform Event : Account_Update_Event__e
- Record Triggered Flow on Account:  Account_After_Save_Flow.flow-meta.xml
- Platform Event Subscriber Flow : Account_Update_Event_Subscriber_Flow.flow-meta.xml

Update Account Risk Field 
<img width="1435" alt="Screenshot 2024-08-05 at 4 20 30 AM" src="https://github.com/user-attachments/assets/cc2abc91-7fb2-4c0a-98db-17280682bd75">

Case Created has difference ownere as of Account when created through Platform Event.
<img width="1434" alt="Screenshot 2024-08-05 at 4 21 11 AM" src="https://github.com/user-attachments/assets/5886b812-b9c0-48b5-9053-f473ecf918a0">








