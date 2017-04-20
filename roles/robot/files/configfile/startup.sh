#!/bin/bash  

DATA_SOURCE=/usr/local/robotframework-auto-test/TODP/TODP-API/

check_opts(){  
    if [ -z "$TEST_SUITE" ]; then   
        echo "use -s to specify the test suite name which you want to run"  
        exit 1  
    fi   
    if [ -z "$DATA_SOURCE" ]; then   
        echo "use -D to specify the data source directory which contains test cases"  
        exit 1  
    fi   
}  

# check arguments count
if [ "$#" -lt 1 ]; then   

cat <<EOF
use option -h to get more information .  
EOF

exit 0  
fi   

# use getopts to define options
while getopts "s:t:i:e:d:T:L:D:h" opt  
do  
    case $opt in  
    s)  
      echo "Test Suite Name is $OPTARG"
      TEST_SUITE=$OPTARG
      TEST_SUITE_C="-s $OPTARG"
      ;;  
    t)  
      echo "Test Case Name is $OPTARG" 
      TEST_CASE=$OPTARG
      TEST_CASE_C="-t $OPTARG"
      ;;  
    i)
      echo "include tag is $OPTARG"
      INCLUDE_TAG=$OPTARG
      INCLUDE_TAG_C="-i $OPTARG"
      ;;
    e)
      echo "exclude tag is $OPTARG"
      EXCLUDE_TAG=$OPTARG
      EXCLUDE_TAG_C="-e $OPTARG"
      ;;
    d)
      echo "output directory is $OPTARG"
      OUTPUT_DIR=$OPTARG
      OUTPUT_DIR_C="-d $OPTARG"
      ;;
    T)
      echo "print timestamp for outputfiles: $OPTARG"
      TIMESTAMP=$OPTARG
      if [ $OPTARG = "true" ]
        then
            TIMESTAMP_C="-T"
        else
            TIMESTAMP_C=""
        fi
      ;;
    L)
      echo "Logging Level is $OPTARG"
      LOGGING_LEVEL=$OPTARG
      LOGGING_LEVEL_C="-L $OPTARG"
      ;;
    D)
      echo "DATA_SOURCE is $OPTARG"
      DATA_SOURCE=$OPTARG
      DATA_SOURCE_C="-D $OPTARG"
      ;;
    h)  
cat <<EOF
Name  
    startup.sh - run robot frameowek test suite
Usage  
    startup.sh  [options] DATA_SOURCE
Options
=======

 -s (required)  Select test suites to run by name. 
                Similarly as name with -t, case and space insensitive and can use patterns. 
                And it can contain parent name separated with a dot. "-s X.Y" selects suite "Y" only if its parent is "X"
                Example: ./startup.sh -s TODP-API.Metadata-API-2.DP-API-MetadataTest* -d /usr/local/output 
                
 -t (optional)  Select test cases to run by name. 
                Case and space insensitive. Also can be a pattern where "*" matches anything and "?" matches any char. 
                Example: ./startup.sh -t Search_obid* -d /usr/local/output 

 -i (optional)  Select test cases to run by tag. 
                Similarly as name with -t, case and space insensitive and can use patterns. 
                Tags and patterns can also be combined together with "AND", "OR", and "NOT" operators.
                Examples: ./startup.sh -s DP-API-MetadataTest* -i getORpost -d /usr/local/output 

 -e (optional)  Select test cases not to run by tag. 
                Tags are matched using the rules explained with -i.
                Examples: ./startup.sh -s DP-API-MetadataTest* -e post -d /usr/local/output 

 -d (optional)  Where to create output files. 
                The default is the directory where tests are run from.
                The given path is considered relative to that unless it is absolute.
                Examples: ./startup.sh -s DP-API-MetadataTest* -e post -d /usr/local/output
 
 -T (optional)  true or false (default is true)
                When this option is true, timestamp in a format "YYYYMMDD-hhmmss" is added to all generated output files.
                such as "output-20161213-134516.xml"/ "log-20161213-134526.html"/ "report-20161213-134526.html"
                Examples: ./startup.sh -T true -s DP-API-MetadataTest* -e post -d /usr/local/output

 -L (optional)  Threshold level for logging. 
                Available levels: TRACE, DEBUG, INFO (default), WARN, NONE (no logging). 
                Examples: --loglevel DEBUG
                Examples: ./startup.sh -L DEBUG -s DP-API-MetadataTest* -e post -d /usr/local/output

 -D (optional)  Data Soucre Directory contains all test cases;
                Usuall we will set a default value for it, such as /usr/local/robotframework-auto-test/TODP/TODP-API
                You can override the default value by using this option
                Example: ./startup.sh -s Metadata-API-2.DP-API-MetadataTest* -i get -e post -T true -L DEBUG -d /usr/local/output -D /usr/local/robotframework-auto-test/TODP/TODP-API

 -h   Print usage instructions.
EOF
      exit 0  
      ;;  
    esac  
done  

# check options
check_opts   

echo "data source directory is: " $DATA_SOURCE
echo "test suite name is: " $TEST_SUITE

if [ -z "$OUTPUT_DIR" ] 
then 
  echo "output directory is: " $OUTPUT_DIR
else
  echo "output directory is current directory"
fi

if [ -z "$INCLUDE_TAG" ];then
  echo "include tag is: " $INCLUDE_TAG
fi

if [ -z "$EXCLUDE_TAG" ];then
  echo "exclude tag is: " $EXCLUDE_TAG
fi

# Run test cases
# ./startup.sh -s Metadata-API-2.DP-API-MetadataTest* -i get -e post -T true -L DEBUG -d /usr/local/output -D /usr/local/robotframework-auto-test/TODP/TODP-API
echo "************************************"
echo "Start to run automatic cases...."
echo "robot command is:"
echo "pybot $TIMESTAMP_C $TEST_SUITE_C $TEST_CASE_C $INCLUDE_TAG_C $EXCLUDE_TAG_C $OUTPUT_DIR_C $LOGGING_LEVEL_C $DATA_SOURCE"
echo "************************************"
pybot $TIMESTAMP_C $TEST_SUITE_C $TEST_CASE_C $INCLUDE_TAG_C $EXCLUDE_TAG_C $OUTPUT_DIR_C $LOGGING_LEVEL_C $DATA_SOURCE 
tail -c 3m -f $OUTPUT_DIR/report*.html



