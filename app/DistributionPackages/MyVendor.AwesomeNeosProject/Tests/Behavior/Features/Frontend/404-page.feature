@playwright
@fixtures
Feature: 404 page handling in frontend

    Background:
        Given I have a site for Site Node "awesomeneosproject"
        Given I have the following nodes:
            | Path                                                           | Node Type                                      | Properties                                                                                                                | HiddenInIndex |
            | /sites                                                         | unstructured                                   | []                                                                                                                        | false         |
            | /sites/awesomeneosproject                                      | MyVendor.AwesomeNeosProject:Document.StartPage | {"uriPathSegment":"awesomeneosproject","title":"AwesomeNeosProject","privacyPage":"b9d32958-9bc0-4502-bdd2-274b54f1777e"} | false         |
            | /sites/awesomeneosproject/notfoundpage/main/node-19au3md0i2yph | MyVendor.AwesomeNeosProject:Content.Headline   | {"title":"<h2>404 - Not found<\/h2>"}                                                                                     | false         |
            | /sites/awesomeneosproject/notfoundpage/main/node-rqdp18zd2snxr | MyVendor.AwesomeNeosProject:Content.Text       | {"text":"The requested document was not found!"}                                                                          | false         |
        And I accepted the Cookie Consent

    Scenario: unknown URL renders the 404 page view
        Given I access the URI path "/something-unknown.html"
        Then there should be the text "404 - Not found" on the page
        And there should be the text "The requested document was not found!" on the page
