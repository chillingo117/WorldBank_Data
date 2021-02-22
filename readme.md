WorldBank_Data

This project is an R based project that accesses data from the worldbank api.
To use:
 - Run getIndicators. This will produce a csv of all indicators available from the worldbank api.
 - Modify and run processIndicators. There is sample code that processes some pre-selected indicators. Replace the indicator id codes with code of your chosing
   (selecting from the csv produced by getIndicators), and replace the variable name with any string you wish. This will produce a csv of cleaned data. 
   Do this at least twice to have at least two datasets to compare and correlate.
 - Modify and run compare. Replace the variable names with the strings you chose in processIndicators. This will produce a scatter plot with a basic trend line using the two 
   datasets selected.
   
There are two versions of each file. One uses jupyterlabs, the other is plain R.
