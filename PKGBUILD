# Contributor: Leslie P. Polzer <polzer@gnu.org>
# Maintainer: Brit Butler <redline6561@gmail.com>

pkgname=paktahn
pkgver=0.9.4.8
libver=0.9.3
pkgrel=1
pkgdesc="The kick-ass package manager for Arch Linux!"
arch=('i686' 'x86_64')
depends=('pacman' 'readline' 'sudo' 'svn')
makedepends=('sbcl>=1.0.32')
license=('GPL')
url="http://github.com/skypher/paktahn"
options=(!strip)
install="paktahn.install"
source=("http://redlinernotes.com/docs/paktahn-makedeps-$libver.tbz2"
        "http://redlinernotes.com/docs/paktahn-${pkgver}.tar.bz2")

build() {
  cd "$srcdir"

  # compile
  SBCL=sbcl

  $SBCL \
       --noinform --lose-on-corruption --end-runtime-options \
       --no-userinit --no-sysinit \
       --eval "(pushnew :paktahn-deploy *features*)" \
       --eval "(require :asdf)" \
       --eval "(setf asdf:*central-registry*
                    '(\"$srcdir/\" \"$srcdir/clbuild.paktahn/systems/\"))" \
       --eval "(asdf:oos 'asdf:load-op 'paktahn)" \
       --eval "(pak::build-core :forkp nil)"

  # install binary
  mkdir -p $pkgdir/usr/bin
  install -m755 paktahn $pkgdir/usr/bin

  # install helper scripts
  mkdir -p $pkgdir/usr/lib/paktahn
  for helper in pkgbuild-helper.sh makepkg-helper.sh; do
    install -m755 "$helper" $pkgdir/usr/lib/paktahn
  done

  # create convenience symlink
  cd $pkgdir/usr/bin
  ln -s paktahn pak
}

md5sums=('aa71c5e639e86bee3afe7d4e27653649'
         'fcdb995fceced619c77124ffdbc68d15')
sha1sums=('1fb3e04732d00c68e7b8aa7ae0a18e9f98359e5f'
          'bea925c7b085fc352e41ef262ada95de9c0b3b71')
md5sums=('aa71c5e639e86bee3afe7d4e27653649'
         '7de65553c5ab8b987d2bde63bdf65aa6')
sha1sums=('1fb3e04732d00c68e7b8aa7ae0a18e9f98359e5f'
          '49d8b48ddae661d64031bbc40652e74ab8692233')
md5sums=('aa71c5e639e86bee3afe7d4e27653649'
         '1bd1867e8435d415f70b18c15bc04e32')
sha1sums=('1fb3e04732d00c68e7b8aa7ae0a18e9f98359e5f'
          '1d28b4275180befe26246dff416abd389633256f')
md5sums=('aa71c5e639e86bee3afe7d4e27653649'
         '1bd1867e8435d415f70b18c15bc04e32')
sha1sums=('1fb3e04732d00c68e7b8aa7ae0a18e9f98359e5f'
          '1d28b4275180befe26246dff416abd389633256f')
md5sums=('aa71c5e639e86bee3afe7d4e27653649'
         '38d8e0cb5117f0df4bf79dfc63a65062')
sha1sums=('1fb3e04732d00c68e7b8aa7ae0a18e9f98359e5f'
          '695f1aca8efe35f1b5981ca24c037999be18127b')
