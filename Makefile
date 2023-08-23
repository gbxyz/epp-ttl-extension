VERSION = 03
DOC = draft-ietf-regext-epp-ttl-$(VERSION)

all:
	@make test
	@make build
	@echo "Done!"

test:
	@echo "Testing example XML files..."
	@find examples -name '*.xml' -exec xmllint --noout --schema xsd/epp.xsd {} \;

build:
	@echo "Compiling XML file..."
	@find examples -name '*.xml' -exec cp -f {} {}.txt \;
	@find examples -name '*-command.xml.txt' -exec sed -i "" "s/^/C:/g" {} \;
	@find examples -name '*-response.xml.txt' -exec sed -i "" "s/^/S:/g" {} \;
	@xmllint --xinclude "draft.xml.in" > "$(DOC).xml"

	@rm -f examples/*.txt

	@xmlstarlet edit --inplace --update '//rfc/@docName' --value "$(DOC)" "$(DOC).xml"
	@xmlstarlet edit --inplace --update '//date/@year' --value $(shell gdate +%Y) "$(DOC).xml"
	@xmlstarlet edit --inplace --update '//date/@month' --value $(shell gdate +%B) "$(DOC).xml"
	@xmlstarlet edit --inplace --update '//date/@day' --value $(shell gdate +%d) "$(DOC).xml"

	@echo "Generating HTML file..."
	@xml2rfc --html "$(DOC).xml"
