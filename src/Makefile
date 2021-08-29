FILENAME = top

$(FILENAME).bo: $(FILENAME).bsv clean
	bsc -sim -g mkTb $(FILENAME).bsv

all: $(FILENAME).bo
	bsc -sim -e mkTb -o $(FILENAME)

clean:
	rm -f model* mkTb* *.bo *.so
