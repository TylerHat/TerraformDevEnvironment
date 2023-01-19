{*$Path = "C:\Users\Tyler Hatfield\.ssh\config"*}
$Path = "C:/Users/Tyler/Documents/ssh/config"
add-content -path $Path -value @'

Host ${hostname}
  HostName ${hostname}
  User ${user}
  IdentityFile ${identityfile}
'@