# archnewscheck pure bash

## about

This is the pure Bash version of archnewscheck. It is more updated and modern than the original Go version, but needs the following commands in your system: curl, sed, seq, xmllint.

## installation

Copy archnewscheck.sh to `/opt` and then make it executable and make a symbolic link to it in a folder in your $PATH. For example:

```
chmod 755 archnewscheck.sh
cd /usr/bin
ln -s /opt/archnewscheck.sh ./archnewscheck
```