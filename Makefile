VERSION = 03
DOC = "draft-ietf-regext-epp-ttl-$(VERSION)"
XML = "$(DOC).xml"

all: test xml build clean

test:
	@echo "Testing example XML files..."
	@find examples -name '*.xml' \( -exec xmllint --noout --schema xsd/epp.xsd {} \; -or -quit \)

xml:
	@find examples -name '*.xml' -exec cp -f {} {}.txt \;
	@find examples -name '*-command.xml.txt' -exec sed -i "" "s/^/C:/g" {} \;
	@find examples -name '*-response.xml.txt' -exec sed -i "" "s/^/S:/g" {} \;

	@echo "Compiling XML file..."
	@xmllint --xinclude "draft.xml.in" > "$(XML)"
	@xmlstarlet edit --inplace --update '//rfc/@docName' 	--value "$(DOC)"           "$(XML)"
	@xmlstarlet edit --inplace --update '//rfc/date/@year'  --value $(shell gdate +%Y) "$(XML)"
	@xmlstarlet edit --inplace --update '//rfc/date/@month' --value $(shell gdate +%B) "$(XML)"
	@xmlstarlet edit --inplace --update '//rfc/date/@day'   --value $(shell gdate +%d) "$(XML)"

build:
	@echo "Generating HTML file..."
	@xml2rfc --html "$(XML)"

	@echo "Generating plaintext file..."
	@xml2rfc "$(XML)"

clean:
	@rm -f examples/*.txt
	@rm -f *txt *html
