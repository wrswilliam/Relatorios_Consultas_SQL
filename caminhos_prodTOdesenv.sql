--SELECT * FROM OADP

--UPDATE OADP
--SET WordPath = CAST(REPLACE(CAST(WordPath AS NVARCHAR),'Eisrvsapap','Eisrvtestsap') AS NTEXT)
--   ,BitmapPath = CAST(REPLACE(CAST(BitmapPath AS NVARCHAR),'Eisrvsapap','Eisrvtestsap') AS NTEXT)
--   ,AttachPath = CAST(REPLACE(CAST(AttachPath AS NVARCHAR),'Eisrvsapap','Eisrvtestsap') AS NTEXT)
--   ,ExtPath = CAST(REPLACE(CAST(ExtPath AS NVARCHAR),'Eisrvsapap','Eisrvtestsap') AS NTEXT)
   

SELECT * FROM [dbo].[@LGNFECONF]

UPDATE [dbo].[@LGNFECONF]
SET U_PathDANFE = CAST(REPLACE(CAST(U_PathDANFE AS NVARCHAR),'Eisrvsapap','Eisrvtestsap') AS NTEXT)
   ,U_PathLogo = CAST(REPLACE(CAST(U_PathDANFE AS NVARCHAR),'Eisrvsapap','Eisrvtestsap') AS NTEXT)
   ,U_PathPDF = CAST(REPLACE(CAST(U_PathPDF AS NVARCHAR),'Eisrvsapap','Eisrvtestsap') AS NTEXT)
   ,U_DirRepDistr = CAST(REPLACE(CAST(U_DirRepDistr AS NVARCHAR),'Eisrvsapap','Eisrvtestsap') AS NTEXT)
   ,U_DirRepCnc = CAST(REPLACE(CAST(U_DirRepCnc AS NVARCHAR),'Eisrvsapap','Eisrvtestsap') AS NTEXT)
   ,U_DirRepDPEC = CAST(REPLACE(CAST(U_DirRepDPEC AS NVARCHAR),'Eisrvsapap','Eisrvtestsap') AS NTEXT)
   ,U_DirRepCCe = CAST(REPLACE(CAST(U_DirRepCCe AS NVARCHAR),'Eisrvsapap','Eisrvtestsap') AS NTEXT)
   ,U_DirRepInut = CAST(REPLACE(CAST(U_DirRepInut AS NVARCHAR),'Eisrvsapap','Eisrvtestsap') AS NTEXT)
   ,U_PathPrintCCe = CAST(REPLACE(CAST(U_PathPrintCCe AS NVARCHAR),'Eisrvsapap','Eisrvtestsap') AS NTEXT)
   ,U_PathPDFCCe = CAST(REPLACE(CAST(U_PathPDFCCe AS NVARCHAR),'Eisrvsapap','Eisrvtestsap') AS NTEXT)