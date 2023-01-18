$Path = "C:\Users\Tyler Hatfield\.ssh\config"
add-content -path $Path -value @'

Host ${hostname}
    Hostname ${hostname}
    User ${user}
    IdentifyFile ${identifyfile}
'@