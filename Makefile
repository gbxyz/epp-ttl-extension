VERSION = 02
DOC = "draft-ietf-regext-epp-ttl-$(VERSION)"
XML = "$(DOC).xml"

all:
	@make test
	@make build
	@echo "Done!"

test:
	@echo "Testing example XML files..."
	@find examples -name '*.xml' \( -exec xmllint --noout --schema xsd/epp.xsd {} \; -or -quit \)

build:
	@echo "Compiling XML file..."
	@find examples -name '*.xml' -exec cp -f {} {}.txt \;
	@find examples -name '*-command.xml.txt' -exec sed -i "" "s/^/C:/g" {} \;
	@find examples -name '*-response.xml.txt' -exec sed -i "" "s/^/S:/g" {} \;
	@xmllint --xinclude "draft.xml.in" > "$(XML)"

	@rm -f examples/*.txt

	@xmlstarlet edit --inplace --update '//rfc/@docName' --value "$(DOC)"           "$(XML)"
	@xmlstarlet edit --inplace --update '//date/@year'   --value $(shell gdate +%Y) "$(XML)"
	@xmlstarlet edit --inplace --update '//date/@month'  --value $(shell gdate +%B) "$(XML)"
	@xmlstarlet edit --inplace --update '//date/@day'    --value $(shell gdate +%d) "$(XML)"

	@echo "Generating HTML file..."
	@xml2rfc --html "$(XML)"

	@echo "Generating plaintext file..."
	@xml2rfc "$(XML)"
