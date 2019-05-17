let
    SQL =
"SELECT
    WH_ACCTCOMMON.EFFDATE ""Date"",
    (CASE WHEN WH_ACCTCOMMON.TAXRPTFORPERSNBR IS NOT NULL THEN 'P' || WH_ACCTCOMMON.TAXRPTFORPERSNBR
        ELSE
            'O' || WH_ACCTCOMMON.TAXRPTFORORGNBR END) ""Entity"",
    WH_ACCTCOMMON.ACCTNBR ""Account Number"",
    DECODE(ACCT.BRANCHORGNBR, 332, 'Beaumont Branch',
        333, 'Beaumont Branch',
        242, 'City Centre',
        240, 'City Centre',
        271, 'University',
        292, 'Westwood',
        'Missing') ""Branch"",
    (CASE WHEN WH_ACCTCOMMON.MJACCTTYPCD IN ('CK', 'SAV') AND WH_ACCTCOMMON.NOTEBAL >= 0
            AND WH_ACCTCOMMON.CURRMIACCTTYPCD NOT IN ('ECSM', 'ECSC') THEN
            'Demand'
        WHEN WH_ACCTCOMMON.MJACCTTYPCD IN ('CK', 'SAV') AND WH_ACCTCOMMON.NOTEBAL < 0
            AND WH_ACCTCOMMON.CURRMIACCTTYPCD NOT IN ('ECSM', 'ECSC') THEN
            'Credit'
        WHEN WH_ACCTCOMMON.MJACCTTYPCD IN ('CNS', 'MTG', 'CML') THEN
            'Credit'
        WHEN WH_ACCTCOMMON.MJACCTTYPCD = 'TD' THEN
            'Investment'
        WHEN WH_ACCTCOMMON.CURRMIACCTTYPCD IN ('ECSM', 'ECSC') THEN
            'Equity'
        ELSE
            'Catagory Required' END) ""Catagory"",
    (CASE WHEN WH_ACCTCOMMON.MJACCTTYPCD = 'CK'
            AND WH_ACCTCOMMON.NOTEBAL >= 0
            AND WH_ACCTCOMMON.TAXRPTFORORGNBR IS NOT NULL THEN
            'Commercial Chequing'
        WHEN WH_ACCTCOMMON.MJACCTTYPCD = 'SAV'
            AND WH_ACCTCOMMON.NOTEBAL >= 0
            AND WH_ACCTCOMMON.TAXRPTFORORGNBR IS NOT NULL
            AND WH_ACCTCOMMON.CURRMIACCTTYPCD NOT IN ('ECSM', 'ECSC') THEN
            'Commercial Savings'
        WHEN WH_ACCTCOMMON.MJACCTTYPCD = 'CK'
            AND WH_ACCTCOMMON.NOTEBAL >= 0
            AND WH_ACCTCOMMON.TAXRPTFORPERSNBR IS NOT NULL THEN
            'Personal Chequing'
        WHEN WH_ACCTCOMMON.MJACCTTYPCD = 'SAV'
            AND WH_ACCTCOMMON.NOTEBAL >= 0
            AND WH_ACCTCOMMON.TAXRPTFORPERSNBR IS NOT NULL
            AND WH_ACCTCOMMON.CURRMIACCTTYPCD NOT IN ('ECSM', 'ECSC') THEN
            'Personal Savings'
        WHEN LOWER(WH_ACCTCOMMON.PRODUCT) LIKE '%mort commercial%' THEN
            'Commercial Mortgage'
        WHEN WH_ACCTCOMMON.MJACCTTYPCD = 'MTG'
            AND WH_ACCTCOMMON.TAXRPTFORORGNBR IS NOT NULL THEN
            'Commercial Mortgage'
        WHEN WH_ACCTCOMMON.MJACCTTYPCD = 'CML' THEN
            'Commercial Credit'
        WHEN WH_ACCTCOMMON.MJACCTTYPCD = 'MTG'
            AND WH_ACCTCOMMON.TAXRPTFORPERSNBR IS NOT NULL THEN
            'Consumer Mortgage'
        WHEN WH_ACCTCOMMON.MJACCTTYPCD = 'CNS'
            AND WH_ACCTCOMMON.PRODUCT LIKE '%HELOC%' THEN
            'Consumer HELOC'
        WHEN WH_ACCTCOMMON.CURRMIACCTTYPCD = 'CN99' THEN
            'Consumer HELOC'
        WHEN WH_ACCTCOMMON.MJACCTTYPCD = 'CNS'
            AND WH_ACCTCOMMON.PRODUCT LIKE '%LOC%' THEN
            'Consumer LOC'
        WHEN WH_ACCTCOMMON.MJACCTTYPCD = 'CNS'
            AND WH_ACCTCOMMON.PRODUCT LIKE '%Term%' THEN
            'Consumer Term Loan'
        WHEN WH_ACCTCOMMON.MJACCTTYPCD = 'CNS' THEN
            'Consumer Credit'
        WHEN WH_ACCTCOMMON.MJACCTTYPCD IN ('CK', 'SAV')
            AND WH_ACCTCOMMON.NOTEBAL < 0
            AND WH_ACCTCOMMON.TAXRPTFORPERSNBR IS NOT NULL THEN
            'Consumer Overdraft'
        WHEN WH_ACCTCOMMON.MJACCTTYPCD IN ('CK', 'SAV')
            AND WH_ACCTCOMMON.NOTEBAL < 0
            AND WH_ACCTCOMMON.TAXRPTFORORGNBR IS NOT NULL THEN
            'Commercial Overdraft'
        WHEN WH_ACCTCOMMON.MJACCTTYPCD = 'TD'
            AND WH_ACCTCOMMON.PRODUCT LIKE '%RSP%'
            AND WH_ACCTCOMMON.DATEMAT - TRUNC(CURRENT_DATE) >= 365 THEN
            'RRSP 1 YR Plus'
        WHEN WH_ACCTCOMMON.MJACCTTYPCD = 'TD'
            AND WH_ACCTCOMMON.PRODUCT LIKE '%RSP%'
            AND WH_ACCTCOMMON.DATEMAT - TRUNC(CURRENT_DATE) < 365 THEN
            'RRSP Less Than 1 YR'
        WHEN WH_ACCTCOMMON.MJACCTTYPCD = 'TD'
            AND WH_ACCTCOMMON.PRODUCT LIKE '%RRIF%'
            AND WH_ACCTCOMMON.DATEMAT - TRUNC(CURRENT_DATE) >= 365 THEN
            'RRIF 1 YR Plus'
        WHEN WH_ACCTCOMMON.MJACCTTYPCD = 'TD'
            AND WH_ACCTCOMMON.PRODUCT LIKE '%RRIF%'
            AND WH_ACCTCOMMON.DATEMAT - TRUNC(CURRENT_DATE) < 365 THEN
            'RRIF Less Than 1 YR'
        WHEN WH_ACCTCOMMON.MJACCTTYPCD = 'TD'
            AND WH_ACCTCOMMON.PRODUCT LIKE '%TD%'
            AND WH_ACCTCOMMON.DATEMAT - TRUNC(CURRENT_DATE) >= 365 THEN
            'TD 1 YR Plus'
        WHEN WH_ACCTCOMMON.MJACCTTYPCD = 'TD'
            AND WH_ACCTCOMMON.PRODUCT LIKE '%TD%'
            AND WH_ACCTCOMMON.DATEMAT - TRUNC(CURRENT_DATE) < 365 THEN
            'TD Less Than 1 YR'
        WHEN WH_ACCTCOMMON.MJACCTTYPCD = 'TD'
            AND WH_ACCTCOMMON.PRODUCT LIKE '%TFSA%'
            AND WH_ACCTCOMMON.DATEMAT - TRUNC(CURRENT_DATE) >= 365 THEN
            'TFSA 1 YR Plus'
        WHEN WH_ACCTCOMMON.MJACCTTYPCD = 'TD'
            AND WH_ACCTCOMMON.PRODUCT LIKE '%TFSA%'
            AND WH_ACCTCOMMON.DATEMAT - TRUNC(CURRENT_DATE) < 365 THEN
            'TFSA Less Than 1 YR'
        WHEN WH_ACCTCOMMON.MJACCTTYPCD = 'TD'
            AND LOWER(WH_ACCTCOMMON.PRODUCT) LIKE '%performance%'
            AND WH_ACCTCOMMON.DATEMAT - TRUNC(CURRENT_DATE) >= 365 THEN
            'Performance 1 YR Plus'
        WHEN WH_ACCTCOMMON.MJACCTTYPCD = 'TD'
            AND LOWER(WH_ACCTCOMMON.PRODUCT) LIKE '%performance%'
            AND WH_ACCTCOMMON.DATEMAT - TRUNC(CURRENT_DATE) < 365 THEN
            'Performance Less Than 1 YR'
        WHEN WH_ACCTCOMMON.CURRMIACCTTYPCD = 'ECSM'
            AND WH_ACCTCOMMON.TAXRPTFORPERSNBR IS NOT NULL THEN
            'Common Share Consumer Balance'
        WHEN WH_ACCTCOMMON.CURRMIACCTTYPCD = 'ECSC'
            AND WH_ACCTCOMMON.TAXRPTFORPERSNBR IS NOT NULL THEN
            'Common Share Consumer Balance (CU Balance)'
        WHEN WH_ACCTCOMMON.CURRMIACCTTYPCD = 'ECSM'
            AND WH_ACCTCOMMON.TAXRPTFORORGNBR IS NOT NULL THEN
            'Common Share Commercial Balance'
        WHEN WH_ACCTCOMMON.CURRMIACCTTYPCD = 'ECSC'
            AND WH_ACCTCOMMON.TAXRPTFORORGNBR IS NOT NULL THEN
            'Common Share Commercial Balance (CU Balance)'
        ELSE
            'Subcatagory Required' END) ""Subcatagory"",
    WH_ACCTCOMMON.PRODUCT ""Product"",
    WH_ACCTCOMMON.OWNERNAME ""Owner"",
    ABS(WH_ACCTCOMMON.NOTEBAL) ""Balance""
FROM WH_ACCTCOMMON
    INNER JOIN ACCT
        ON WH_ACCTCOMMON.ACCTNBR = ACCT.ACCTNBR
WHERE
    (WH_ACCTCOMMON.EFFDATE = TRUNC(CURRENT_DATE -1)
    OR (WH_ACCTCOMMON.MONTHENDYN = 'Y'
        AND WH_ACCTCOMMON.EFFDATE >= ADD_MONTHS(TRUNC(CURRENT_DATE), -24)))
    AND WH_ACCTCOMMON.CURRACCTSTATCD NOT IN ('CLS', 'CO', 'DORM')
    AND LOWER(WH_ACCTCOMMON.PRODUCT) NOT LIKE '%internal%'
ORDER BY
    WH_ACCTCOMMON.EFFDATE DESC",

    BBSource = Table.AddColumn(
        Oracle.Database("BCUDatabase", [Query = ""&SQL&""]),
    "Source DB", each "Beaumont", type text),
    CCSource = Table.AddColumn(
        Oracle.Database("RCCUDatabase", [Query = ""&SQL&""]),
    "Source DB", each "City Centre", type text),
    ABCUSource = Table.Combine({BBSource, CCSource}),
    #"Changed Type" = Table.TransformColumnTypes(ABCUSource,{{"Date", type date}}),

    #"Added Portfolios" = Table.ExpandTableColumn(
        Table.NestedJoin(#"Changed Type", {"Entity", "Source DB"}, Portfolios, {"Entity", "Source DB"}, "Port", JoinKind.LeftOuter),
    "Port", {"Portfolio"}),

    #"Added Previous Month" = Table.AddColumn(#"Added Portfolios", "Previous Month",
        each Date.EndOfMonth(Date.AddMonths([Date], -1)), type date),
    #"Added Previous Year" = Table.AddColumn(#"Added Previous Month", "Previous Year",
        each Date.EndOfMonth(Date.AddMonths([Date], -12)), type date),

    #"Added Type" = Table.AddColumn(#"Added Previous Year", "Type",
        each if Text.Range([Entity], 0, 1) = "O" then "Org" else "Pers", type text),

    #"Grouped Results" = Table.Group(#"Added Type", {"Date", "Previous Month", "Previous Year", "Branch", "Portfolio", "Type", "Catagory", "Subcatagory", "Product"},
        {{"Balance", each List.Sum([Balance]), type number}}),


//The below sections rejoins the table to ABCUSource to bring in prior month and prior year balances
    #"Added Previous Month Balances" = Table.ExpandTableColumn(
        Table.NestedJoin(#"Grouped Results", {"Previous Month", "Branch", "Portfolio", "Type", "Catagory", "Subcatagory", "Product"},
        #"Grouped Results", {"Date", "Branch", "Portfolio", "Type", "Catagory", "Subcatagory", "Product"}, "priMthBal", JoinKind.LeftOuter),
    "priMthBal", {"Balance"}, {"Previous Month Balance"}),
    #"Added Previous Year Balances" = Table.ExpandTableColumn(
        Table.NestedJoin(#"Added Previous Month Balances", {"Previous Year", "Branch", "Portfolio", "Type", "Catagory", "Subcatagory", "Product"},
        #"Grouped Results", {"Date", "Branch", "Portfolio", "Type", "Catagory", "Subcatagory", "Product"}, "priMthBal", JoinKind.LeftOuter),
    "priMthBal", {"Balance"}, {"Previous Year Balance"}),
    #"Replaced Value" = Table.ReplaceValue(#"Added Previous Year Balances",null,0,Replacer.ReplaceValue,{"Previous Month Balance", "Previous Year Balance"}),

//Below section creates columns that identifies trends
    #"Added MoM Change" = Table.AddColumn(#"Replaced Value", "MoM Change ($)", each [Balance] - [Previous Month Balance], type number),
    #"Added YoY Change" = Table.AddColumn(#"Added MoM Change", "YoY Change ($)", each [Balance] - [Previous Year Balance], type number),
    #"Filtered Rows" = Table.SelectRows(#"Added YoY Change",
        each Date.AddMonths(Date.From(DateTime.LocalNow()), -12) <= [Date])
in
    #"Filtered Rows"
