ConnectionDetails <- DatabaseConnector::createConnectionDetails(dbms = "sql server",
                                                                server = "",  #IP
                                                                schema = "master.dbo" ,
                                                                user = "",        #User id
                                                                password = "")

cdmSchema <- 'cdmSchema.dbo'
metaSchema <- 'metaSchema.dbo'
resultSchema<- 'resultSchema.dbo'
level = 3
useRandomExtraction = T
extractioncdmSchema = 'extractioncdmSchema.dbo'
randParameter = 10000
etl_stdt = '1995-01-01'
etl_endt = '2015-12-31'
createddl = T
cdmAnalysis = T
makeShinyData = T
useVisnetwork=T
runShiny =T
visnetworkCsvPath =c('metacsvfilepath','cdmcsvfilepath')
outputFolder = getwd()
verboseMode = T

DQUEEN::dqueen(ConnectionDetails,
               level,
               etl_stdt,
               etl_endt,
               cdmSchema,
               metaSchema,
               resultSchema,
               useRandomExtraction,
               extractioncdmSchema,
               randParameter,
               createddl,
               cdmAnalysis,
               makeShinyData,
               useVisnetwork,
               visnetworkCsvPath,
               runShiny,

)
