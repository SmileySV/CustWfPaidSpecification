--declare @dataareaid nvarchar(4) = 'ztoe';
--declare @periodfrom datetime = '20210601';
--declare @periodto datetime = '20210731';
--declare @execguid nvarchar(255) = 'AED5D037-48DC-4FA8-B576-5F7A743CCE01';
IF @showAllTotals = 0
	BEGIN
WITH term_expired AS (
SELECT rct2.RContractId_UA AS teRContractID
FROM RContractTable AS rct2
WHERE rct2.dataareaid = @dataareaid
AND rct2.RContractCode = 141
AND rct2.ContractStartDate between @periodfrom and @periodto
AND ((CASE WHEN (rct2.ContractEndDate = convert(date,'01.01.1900',104)) then null else rct2.ContractEndDate END) IS NOT NULL)
AND rct2.ContractEndDate < @periodto
AND (((SELECT MIN(ctr.transDate) FROM CustTrans AS ctr WHERE ctr.dataareaid = @dataareaid AND rct2.RContractId_UA = ctr.DIMENSION5_ AND ctr.TransType = 15 AND ctr.AmountCur < 0) IS NULL) OR ((rct2.ContractEndDate < (SELECT MIN(ctr.transDate) FROM CustTrans AS ctr WHERE ctr.dataareaid = @dataareaid AND rct2.RContractId_UA = ctr.DIMENSION5_ AND ctr.TransType = 15 AND ctr.AmountCur < 0)) AND ((SELECT TOP(1) rcaa.RContractId FROM RContractAddAgreement_UA AS rcaa WHERE rcaa.RContractId = rct2.RContractId_UA AND rcaa.dataareaid = @dataareaid) IS NULL))))
SELECT rct.Dimension AS Site, rct.NumberTU AS NumberTU, rct.NumContractTU AS NumContractTU, rct.RegistrationDate AS TYRegDate, rct.RContractNumber AS RContractNumber, 
rct.ContractDate AS ContractDate, rct.PowerOrderedForJoining2 AS PowerOrderedForJoining2, rct.AccessionType AS AccessionType, (YEAR(rct.PlannedDate)) AS PlannedYear,
CASE 
	WHEN rct.AccountNumName = '' THEN (SELECT rt.Name FROM RassetTable rt WHERE rt.dataareaid = @dataareaid AND rt.AccountNum = rct.AccountNum)
	WHEN rct.AccountNumName <> '' THEN rct.AccountNumName
	END PowerPointName,
rct.VoltaeOverall AS PowerJoinVoltage, 
rct.CustWfContractType AS CustWfContractType, rct.MoneyDate AS MoneyDate,
(SELECT TOP(1) hrmo.description FROM RPayHRMOrganization hrmo WHERE hrmo.dataareaid = @dataareaid AND rct.dimension = hrmo.hrmOrganizationId AND hrmo.azt_startdate = (SELECT MAX(hrmo2.azt_startdate) FROM RPayHRMOrganization hrmo2 WHERE hrmo2.dataareaid = @dataareaid AND rct.dimension = hrmo2.hrmOrganizationId )) AS rctDescription
,(SELECT min(ct.TransDate) FROM CustTrans AS ct WHERE rct.RContractId_UA = ct.DIMENSION5_) AS minfpDate, rct.AccountNumName AS AccountNumName, term_expired.teRContractID AS TermExpiredId
FROM RContractTable AS rct
LEFT JOIN CustTrans AS ct
ON rct.RContractId_UA = ct.DIMENSION5_
AND ct.TransType = 15 
AND ct.dataareaid = @dataareaid
LEFT JOIN term_expired ON term_expired.teRContractID = rct.RContractId_UA
WHERE (rct.RContractCode = 141)
AND rct.dataareaid = @dataareaid
AND (rct.RegistrationDate between @periodfrom and @periodto)
AND rct.CustWFDocIdInb2 = ''
AND rct.STAGE_UA <> 4
GROUP BY NumContractTU,
rct.Dimension , rct.NumberTU , rct.NumContractTU , rct.RegistrationDate , rct.RContractNumber, 
rct.ContractDate , rct.PowerOrderedForJoining2 , rct.AccessionType , (YEAR(rct.PlannedDate)) ,rct.AccountNum,rct.AccountNumName,rct.VoltaeOverall,rct.CustWfContractType,rct.MoneyDate, rct.RContractId_UA, term_expired.teRContractID
ORDER BY NumContractTU
	END
ELSE
IF @showAllTotals = 1
	BEGIN
WITH term_expired AS (
SELECT rct2.RContractId_UA AS teRContractID
FROM RContractTable AS rct2
WHERE rct2.dataareaid = @dataareaid
AND rct2.RContractCode = 141
AND rct2.ContractStartDate between @periodfrom and @periodto
AND ((CASE WHEN (rct2.ContractEndDate = convert(date,'01.01.1900',104)) then null else rct2.ContractEndDate END) IS NOT NULL)
AND rct2.ContractEndDate < @periodto
AND ((((SELECT MIN(ctr.transDate) FROM CustTrans AS ctr WHERE ctr.dataareaid = @dataareaid AND rct2.RContractId_UA = ctr.DIMENSION5_ AND ctr.TransType = 15 AND ctr.AmountCur < 0) IS NULL) AND rct2.dateofissue > convert(date,'28.01.2022',104)) OR ((rct2.ContractEndDate < (SELECT MIN(ctr.transDate) FROM CustTrans AS ctr WHERE ctr.dataareaid = @dataareaid AND rct2.RContractId_UA = ctr.DIMENSION5_ AND ctr.TransType = 15 AND ctr.AmountCur < 0)) AND ((SELECT TOP(1) rcaa.RContractId FROM RContractAddAgreement_UA AS rcaa WHERE rcaa.RContractId = rct2.RContractId_UA AND rcaa.dataareaid = @dataareaid) IS NULL))))
SELECT rct.Dimension AS Site, rct.NumberTU AS NumberTU, rct.NumContractTU AS NumContractTU, rct.RegistrationDate AS TYRegDate, rct.RContractNumber AS RContractNumber, 
rct.ContractDate AS ContractDate, rct.PowerOrderedForJoining2 AS PowerOrderedForJoining2, rct.AccessionType AS AccessionType, (YEAR(rct.PlannedDate)) AS PlannedYear,
CASE 
	WHEN rct.AccountNumName = '' THEN (SELECT rt.Name FROM RassetTable rt WHERE rt.dataareaid = @dataareaid AND rt.AccountNum = rct.AccountNum)
	WHEN rct.AccountNumName <> '' THEN rct.AccountNumName
	END PowerPointName,
rct.VoltaeOverall AS PowerJoinVoltage, 
rct.CustWfContractType AS CustWfContractType, rct.MoneyDate AS MoneyDate,
(SELECT TOP(1) hrmo.description FROM RPayHRMOrganization hrmo WHERE hrmo.dataareaid = @dataareaid AND rct.dimension = hrmo.hrmOrganizationId AND hrmo.azt_startdate = (SELECT MAX(hrmo2.azt_startdate) FROM RPayHRMOrganization hrmo2 WHERE hrmo2.dataareaid = @dataareaid AND rct.dimension = hrmo2.hrmOrganizationId )) AS rctDescription
,(SELECT min(ct.TransDate) FROM CustTrans AS ct WHERE rct.RContractId_UA = ct.DIMENSION5_) AS minfpDate, rct.AccountNumName AS AccountNumName, term_expired.teRContractID AS TermExpiredId
FROM RContractTable AS rct
LEFT JOIN CustTrans AS ct
ON rct.RContractId_UA = ct.DIMENSION5_
AND ct.TransType = 15 
AND ct.dataareaid = @dataareaid
LEFT JOIN term_expired ON term_expired.teRContractID = rct.RContractId_UA
WHERE (rct.RContractCode = 141)
AND rct.dataareaid = @dataareaid
AND (rct.RegistrationDate between @periodfrom and @periodto)
AND rct.CustWFDocIdInb2 = ''
AND rct.STAGE_UA <> 4
AND rct.CustWFDocIdOut4 = ''
AND (((SELECT min(ct.TransDate) FROM CustTrans AS ct WHERE rct.RContractId_UA = ct.DIMENSION5_) <> '') OR (((SELECT min(ct.TransDate) FROM CustTrans AS ct WHERE rct.RContractId_UA = ct.DIMENSION5_) IS NULL) AND rct.dateofissue > convert(date,'28.01.2022',104)))
GROUP BY NumContractTU,
rct.Dimension , rct.NumberTU , rct.NumContractTU , rct.RegistrationDate , rct.RContractNumber, 
rct.ContractDate , rct.PowerOrderedForJoining2 , rct.AccessionType , (YEAR(rct.PlannedDate)) ,rct.AccountNum,rct.AccountNumName,rct.VoltaeOverall,rct.CustWfContractType,rct.MoneyDate, rct.RContractId_UA, term_expired.teRContractID 
ORDER BY NumContractTU
	END