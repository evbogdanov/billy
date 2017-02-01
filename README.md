# billy

I've got bills to pay.

```

$$\       $$\ $$\ $$\           
$$ |      \__|$$ |$$ |          
$$$$$$$\  $$\ $$ |$$ |$$\   $$\ 
$$  __$$\ $$ |$$ |$$ |$$ |  $$ |
$$ |  $$ |$$ |$$ |$$ |$$ |  $$ |
$$ |  $$ |$$ |$$ |$$ |$$ |  $$ |
$$$$$$$  |$$ |$$ |$$ |\$$$$$$$ |
\_______/ \__|\__|\__| \____$$ |
                      $$\   $$ |
                      \$$$$$$  |
                       \______/ 

```

## Run development server
```
$ script/billy_server.pl -r
```

## Run with Plack
```
$ plackup billy.psgi
```

## Testing
```
$ CATALYST_DEBUG=0 prove -wl t
```
