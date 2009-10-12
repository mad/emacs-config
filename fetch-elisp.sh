#! /bin/bash

CVS_PATH="/pub/cvs/"
GIT_PATH="/pub/git/"
SVN_PATH="/pub/svn/"

EMACS_DIR="$HOME/.emacs.d/elisp/"

## CVS
cd $CVS_PATH
cvs -z3 -d:pserver:anonymous@cvs.savannah.gnu.org:/sources/auctex co auctex
cd auctex
./autogen.sh
./configure --prefix=/usr
make
ln -s $CVS_PATH/auctex $EMACS_DIR/auctex

cd $CVS_PATH
cvs -z9 -d :pserver:anonymous@cvs.m17n.org:/cvs/root checkout apel
cd apel
make
ln -s $CVS_PATH/apel $EMACS_DIR/apel

cd $CVS_PATH
cvs -z3 -d:pserver:anonymous@cedet.cvs.sourceforge.net:/cvsroot/cedet co -P cedet
cd cedet
make
ln -s $CVS_PATH/cedet $EMACS_DIR/cedet

cd $CVS_PATH
cvs -z3 -d:pserver:anonymous@ecb.cvs.sourceforge.net:/cvsroot/ecb co ecb
cd ecb
make
ln -s $CVS_PATH/ecb $EMACS_DIR/ecb

cd $CVS_PATH
cvs -z3 -d:pserver:anonymous:anonymous@common-lisp.net:/project/slime/cvsroot co slime
ln -s $CVS_PATH/slime $EMACS_DIR/slime

## GIT

cd $GIT_PATH
git clone git://git.sv.gnu.org/emms.git
cd emms
make
ln -s $GIT_PATH/emms/lisp $EMACS_DIR/emms

cd $GIT_PATH
git clone http://git.savannah.gnu.org/cgit/identica-mode.git
ln -s $GIT_PATH/identica-mode/identica-mode.el $EMACS_DIR/identica-mode.el

cd $GIT_PATH
git clone git://catap.ru/emacs-jabber/emacs-jabber.git
cd emacs-jabber
make
ln -s $GIT_PATH/emacs-jabber $EMACS_DIR/jabber

cd $GIT_PATH
git clone git@github.com:mad/emacs-juick-el.git
ln -s $GIT_PATH/emacs-juick-el $EMACS_DIR/juick-el

cd $GIT_PATH
git clone git://gitorious.org/magit/mainline.git magit
cd magit
./autogen.sh
./configure --prefix=/usr
make
ln -s $GIT_PATH/magit/magit.el $EMACS_DIR/magit.el
ln -s $GIT_PATH/magit/magit.elc $EMACS_DIR/magit.elc

cd $GIT_PATH
git clone git://jblevins.org/git/markdown-mode.git
ln -s $GIT_PATH/markdown-mode/markdown-mode.el $EMACS_DIR/markdown-mode.el

cd $GIT_PATH
git clone git@github.com:mad/slackware-el.git
ln -s $GIT_PATH/slackware-el/slackware-changelog.el $EMACS_DIR/slackware-changelog.el

cd $GIT_PATH
git clone http://git.busydoingnothing.co.uk/cgit.cgi/twitter.git
ln -s $GIT_PATH/twitter/twitter.el $EMACS_DIR/twitter.el
git clone git://github.com/hayamiz/twittering-mode.git


## SVN
cd $SVN_PATH
svn checkout http://yasnippet.googlecode.com/svn/trunk/ yasnippet-read-only
ln -s $SVN_PATH/yasnippet-read-only $EMACS_DIR/yasnippet

cd $SVN_PATH
svn checkout http://js2-mode.googlecode.com/svn/trunk/ js2-mode-read-only
ln -s $SVN_PATH/js2-mode-read-only/js2-build.el $EMACS_DIR/js2-build.el

cd $EMACS_DIR/
mkdir company
wget http://nschum.de/src/emacs/company-mode/company-0.4.3.tar.bz2
tar xjf company-0.4.3.tar.bz2
mv *.el company
rm -rf company-0.4.3.tar.bz2