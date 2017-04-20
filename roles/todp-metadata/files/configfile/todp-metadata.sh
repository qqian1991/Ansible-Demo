#! /bin/bash
/usr/lib/todp-metadata-web/bin/run.sh start 
tail -c 3m -f /usr/lib/todp-metadata-web/logs/std.out
