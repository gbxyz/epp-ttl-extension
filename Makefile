VERSION = 06
DOC = "draft-ietf-regext-epp-ttl-$(VERSION)"
XML = "$(DOC).xml"

all: html

lint:
	@echo "Running lint check..."

	@xmllint --noout draft.xml.in 

test: lint
	@echo "Testing example XML files..."

	@find examples -name '*.xml' -print \( -exec xmllint --noout --schema xsd/epp.xsd {} \; -or -quit \)

xml: test
	@echo "Compiling XML file..."

	@find examples -name '*.xml' -exec cp -fv {} {}.txt \;
	@find examples -name '*-command.xml.txt' -exec sed -i "" "s/^/C:/g" {} \;
	@find examples -name '*-response.xml.txt' -exec sed -i "" "s/^/S:/g" {} \;

	@xmllint --xinclude "draft.xml.in" > "$(XML)"
	@xmlstarlet edit --inplace --update '//rfc/@docName' --value "$(DOC)" "$(XML)"

html: xml
	@echo "Generating HTML file..."
	@xml2rfc --html "$(XML)"

clean:
	@echo "Cleaning up..."
	@rm -fv examples/*.txt
	@rm -fv *txt *html
