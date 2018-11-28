/****** Object:  StoredProcedure [FRONTDOOR].[sp_StuckInSubmitted]    Script Date: 2018. 10. 15. 14:01:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--exec [FRONTDOOR].[sp_StuckInSubmitted]
--select * from [Reports].[FrontDoor_StuckInSubmitted]
-- truncate table [Reports].[FrontDoor_StuckInSubmitted]

CREATE OR ALTER PROCEDURE [FRONTDOOR].[sp_StuckInSubmitted]
AS
BEGIN

EXEC dbo.sp_MIDAS_StatusUpdate 'Frontdoor: StoredProcedure', '[FRONTDOOR].[sp_StuckInSubmitted] started'

truncate table [Reports].[FrontDoor_StuckInSubmitted]

insert into [Reports].[FrontDoor_StuckInSubmitted]
SELECT distinct
		R.OrgName
		,case when R.OrgName = 'ES'   then 'https://ent302.sharepoint.hpe.com/teams/frontdoor/Lists/Requests/EditForm.aspx?ID='+ CAST(R.ID as varchar)  
				when R.OrgName = 'CSC' then 'https://dxcportal.sharepoint.com/sites/frontdoor/Lists/Requests/EditForm.aspx?ID='+ CAST(R.ID as varchar)  
				else '' end as [Change the Status] 
		,case when R.OrgName = 'ES'    then 'https://ent302.sharepoint.hpe.com/teams/frontdoor/SitePages/NewRequestForm.aspx?requestListItemId='+ CAST(R.ID as varchar) 
				when R.OrgName = 'CSC'  then 'https://dxcportal.sharepoint.com/sites/frontdoor/SitePages/NewRequestForm.aspx?requestListItemId='+ CAST(R.ID as varchar)  
				else '' end as [Submit Link]
		,case when R.OrgName = 'ES'    then 'https://ent302.sharepoint.hpe.com/teams/frontdoor/SitePages/FulfilmentRequestForm.aspx?requestListItemId='+ CAST(R.ID as varchar)  
				when R.OrgName = 'CSC'  then 'https://dxcportal.sharepoint.com/sites/frontdoor/SitePages/FulfilmentRequestForm.aspx?requestListItemId='+ CAST(R.ID as varchar) 
				else '' end as [Fulfil Link]
		,R.ID AS [Request ID]
		,RS.ID AS [Service ID]
		,R.RequestName
		,R.CreatedBy
		,R.Created
		,R.SubmittedDate
		,CAST(SC.Service AS VARCHAR) as 'Service'
		,RS.Route
		--,R.FromFun AS [Request Type]
		--,E.Subject 
		,ReqStatus.ListValue --R.RequestStatus
		,RS.ServiceStatus
FROM FRONTDOOR.Requests R
LEFT JOIN FRONTDOOR.RequestedServices  RS
	ON R.ID = RS.RequestNumericID
	and R.OrgName = RS.OrgName 
LEFT JOIN FRONTDOOR.ServiceCatalog  SC
	ON CAST(RS.ServiceID AS VARCHAR) = CAST(SC.ID AS VARCHAR)
		and RS.OrgName = SC.OrgName
LEFT JOIN FRONTDOOR.EmailOutbox E
	ON RS.RequestNumericID = E.RequestID 
	and RS.OrgName = E.OrgName
LEFT JOIN (select distinct ID,ListValue from FRONTDOOR.tbl_FDLookupValues where ListName='RequestStatus') ReqStatus
	ON ReqStatus.ID = R.RequestStatus
WHERE R.RequestStatus=2

EXEC dbo.sp_MIDAS_StatusUpdate 'Frontdoor: StoredProcedure', '[FRONTDOOR].[sp_StuckInSubmitted] completed'

END
GO


