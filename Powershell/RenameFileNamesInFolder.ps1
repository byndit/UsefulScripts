$nr = 1
Dir | %{Rename-Item $_ -NewName ("Blavand{0}.jpg" -f $script:nr++)}