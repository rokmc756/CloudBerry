# hdfs dfs -mkdir -p /data/pxf_examples
# echo 'Prague,Jan,101,4875.33
# Rome,Mar,87,1557.39
# Bangalore,May,317,8936.99
# Beijing,Jul,411,11600.67' > /tmp/pxf-hdfs-simple-data.txt

# hdfs dfs -put /tmp/pxf-hdfs-simple-data.txt /data/pxf_examples/
hdfs dfs -put /home/hadoop/query-examples/pxf-hdfs-simple-data.txt /data/pxf_examples/
hdfs dfs -cat /data/pxf_examples/pxf-hdfs-simple-data.txt
