CABAL = cabal


all:
	${CABAL} build -j1
	mv dist-newstyle/build/x86_64-linux/ghc-8.8.4/matcha-latte-0.1.0.0/x/interpreter/build/interpreter/interpreter interpreter



install:
	${CABAL} install --install-method=copy --installdir=./ --overwrite-policy=always


clean:
	${CABAL} clean
	rm interpreter