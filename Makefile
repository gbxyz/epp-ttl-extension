VERSION = 03
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
	@echo "Generating examples..."
	@find examples -name '*.xml' -exec cp -f {} {}.txt \;
	@find examples -name '*-command.xml.txt' -exec sed -i "" "s/^/C:/g" {} \;
	@find examples -name '*-response.xml.txt' -exec sed -i "" "s/^/S:/g" {} \;

	@echo "Compiling XML file..."
	@xmllint --xinclude "draft.xml.in" > "$(XML)"
	@xmlstarlet edit --inplace --update '//rfc/@docName' --value "$(DOC)"           "$(XML)"
	@xmlstarlet edit --inplace --update '//date/@year'   --value $(shell gdate +%Y) "$(XML)"
	@xmlstarlet edit --inplace --update '//date/@month'  --value $(shell gdate +%B) "$(XML)"
	@xmlstarlet edit --inplace --update '//date/@day'    --value $(shell gdate +%d) "$(XML)"

	@echo "Generating HTML file..."
	@xml2rfc --html "$(XML)"

	@echo "Generating plaintext file..."
	@xml2rfc "$(XML)"

	@rm -f examples/*.txt
