#/usr/bin/sh
expect -c "
set timeout 100;
set flag 0;
$1;
expect {
  \"*assword*\" { send \"$2\r\"; };
  \"yes\/no\" { set flag 1;send \"yes\r\";};
  \"welcome\" { };
};
if { \$flag == 1 } { 
  expect {
    \"*assword*\" { send \"$2\r\"; };
  }; 
};"