cfg () 
{ 
    : ${build=$(${CC-gcc} -dumpmachine | sed "s/-pc-/-/ ;; s/linux/pc-&/")}
    : ${host=$build}
    : ${builddir=build/$host}
    : ${prefix=/usr}

     : ${PKG_CONFIG_PATH="$prefix/lib/pkgconfig:$prefix/share/pkgconfig"}
     export PKG_CONFIG_PATH

    mkdir -p $builddir;
    relsrcdir=$(realpath --relative-to="$builddir" $PWD)
    ( set -x; cd $builddir;
    "$relsrcdir"/configure \
          --prefix=$prefix \
          --sysconfdir=/etc \
          --localstatedir=/var \
          --libdir=$prefix/lib \
          ${host+--host="$host"} \
          ${build+--build="$build"} \
          --disable-{silent-rules,libtool-lock} \
          "$@"
    )

}

cfg-diet() {
 (: ${build=$(${CC:-gcc} -dumpmachine)}
  : ${host=${build/-gnu/-dietlibc}}
  : ${builddir=build/$host}
  : ${prefix=/opt/diet}
  : ${libdir=/opt/diet/lib-${host%%-*}}
  : ${bindir=/opt/diet/bin-${host%%-*}}
  
  : ${CC="diet-gcc"}
  : ${PKG_CONFIG="$host-pkg-config"}

  export CC PKG_CONFIG

  cfg \
    --disable-shared \
    --enable-static \
    "$@")
}
