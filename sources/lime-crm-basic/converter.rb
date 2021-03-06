# encoding: UTF-8
require 'move-to-go'

# Customize this file to suit your LIME Pro database structure.
#
# Documentation move-to-go can be found at
# http://rubygems.org/gems/move-to-go
#
# move-to-go contains all objects in LIME Go such as organization,
# people, deals, etc. What properties each object has is described in
# the documentation.
#
# *** NOTE:
#
# Integration-ID and LIME-links are automatically created for each
# object

# *** TODO:
#
# You must customize this template so it works with your LIME Pro
# database. Modify each to_* method and set properties on the LIME Go
# object.
#

############################################################################
# Constants
# Edit these constants to fit your needs

# Connection to the SQL-server
# You can use either an AD-account or SQL-user credentials to authenticate.
# You will be prompted for the password when you run the import.
#
# Remove SQL_SERVER_USER or leave it empty if you want to connect with
# the user that is running move-to-go.
SQL_SERVER = ''
SQL_SERVER_DATABASE = ''
SQL_SERVER_USER = ''

# LIME Server 
LIME_SERVER = ''
LIME_DATABASE = ''
LIME_LANGUAGE = 'sv' # Used for the values in set and option fields

# Companies
# Set the name of the relation field to the responsible coworker
ORGANIZATION_RESPONSIBLE_FIELD = 'coworker'

# Deals
# Set if deals should be imported and name of relationfields.
# Defaults should work well.
IMPORT_DEALS = false
DEAL_RESPONSIBLE_FIELD = 'coworker'
DEAL_COMPANY_FIELD = 'company'

# Notes
# Set if notes should be imported and name of relationfields.
# Defaults should work well
IMPORT_HISTORY = true
HISTORY_COWORKER_FIELD = 'coworker'
HISTORY_COMPANY_FIELD = 'company'
HISTORY_PERSON_FIELD = 'person'
HISTORY_DEAL_FIELD = 'business'

############################################################################

class Converter

    # The to_coworker, to_organization, etc methods takes a LIME Go
    # object (a coworker or organization etc) where some basic
    # properties already has been set. The methods will also have a
    # row argument that represents the database row in LIME Pro. Some
    # methods will also get the rootmodel. You can use the rootmodel
    # if you need to lookup coworkers or other object.
    #
    # The to_ methods should return the object that is provided as argument.
    #
    # We have included some sample code that shows how to set
    # different properties. However, the goal is that you should NOT
    # have to modify anything to get a basic import of a LIME Pro Core
    # database.


    # The following properties are set on the coworker by default:
    #
    # LIME Go field                                LIME Pro field label
    # coworker.first_name and coworker.last_name   Name
    # coworker.email                               PrimaryEmail
    # coworker.direct_phone_number                 BusinessTelephoneNumber
    # coworker.mobile_phone_number                 MobileTelephoneNumber
    def to_coworker(coworker, row)
        # If your database dont have fields with the specifed labels,
        # you must set properties as below.

        # coworker.first_name = row["firstname"]
        # coworker.last_name = row["lastname"]
        # coworker.direct_phone_number = row["phone"]
        # coworker.mobile_phone_number = row["cellphone"]
        # coworker.email = row["email"]

        return coworker
    end

    # The following properties are set on the organization by default:
    #
    # LIME Go field                                LIME Pro field label
    # organization.name                            Name
    # organization.organization_number             CompanyNumber
    # organization.email                           PrimaryEmailAddress
    # organization.web_site                        BusinessHomePage
    # organization.central_phone_number            BusinessTelephoneNumber
    # organization.postal_address.street           StreetAddress + StreetAddress2
    # organization.postal_address.zip_code         ZipCode
    # organization.postal_address.city             City
    # organization.postal_address.country          Country
    # organization.visit_address.street            VisitingAddressStreetAddress + VisitingAddressStreetAddress2
    # organization.visit_address.zip_code          VisitingAddressZipCode
    # organization.visit_address.city              VisitingAddressCity
    # organization.visit_address.country           VisitingAddressCountry
    def to_organization(organization, row)
        # If your database dont have fields with the specifed labels,
        # you must set properties as below.
        
        # organization.name = row['name']
        # organization.organization_number = row['registrationno']

        ####################################################################
        ## Bisnode ID fields

        # NOTE!!! If a bisnode-id is present you dont need to set
        # fields like address or website since they are reterived from
        # PAR.

        # bisnode_id = row['parid']

        # if bisnode_id && !bisnode_id.empty?
        #     organization.with_source do |source|
        #         source.par_se(bisnode_id)
        #     end
        # end

        # If a company is missing a bisnode ID then you should do this
        # in order to capture any possible data that is written manually
        # on that company.

        # if bisnode_id && bisnode_id.empty?
        #      organization.web_site = row['website']
        #      organization.central_phone_number = row['phone']
        

        #     ####################################################################
        #     # Address fields.
        #     # Addresses consists of several parts in LIME Go. Lots of other
        #     # systems have the address all in one line, to be able to
        #     # match when importing it is way better to split the addresses

        #     organization.with_postal_address do |address|
        #         address.street = row['potstaladdress1']
        #         address.zip_code = row['postalzipcode']
        #         address.city = row['postalcity']
        #     end

        #     # Same as visting address

        #     organization.with_visit_address do |addr|
        #         addr.street = row['visitingaddress1']
        #         addr.zip_code = row['visitingzipcode']
        #         addr.city = row['visitingcity']
        #     end
        # end
        #####################################################################
        ## Tags.
        # Set tags for the organization. All organizations will get
        # the tag "import" automagically

        # organization.set_tag("Guldkund")

        #####################################################################
        ## Option fields.
        # Option fields are normally translated into tags
        # The option field customer category for instance,
        # has the options "A-customer", "B-customer", and "C-customer"
        
        # case row['businessarea']
        # when 'Marketing', 'Sales'
        #     organization.set_tag(row['businessarea'])
        # end

        #####################################################################
        ## Set fields.
        # Set fields are normally translated into tags
        # A field is a ";"- separated list. We must first split them into
        # an array.

        # values = row["mailings"].split(";")
        # values.each do |value|
        #     if value = "Newsletter"
        #         organization.set_tag(value)
        #     end
        # end

        #####################################################################
        ## LIME Go Relation.
        # let's say that there is a option field in Easy called 'Customer relation'
        # with the options '1.Customer', '2.Prospect' '3.Partner' and '4.Lost customer'

        # case row['relation'] 
        # when '1.Customer'
        # We have made a deal with this organization.
        #    organization.relation = MoveToGo::Relation::IsACustomer
        # when '2.Prospect'
        # Something is happening with this organization, we might have
        # booked a meeting with them or created a deal, etc.
        #    organization.relation = MoveToGo::Relation::WorkingOnIt
        # when '4.Lost customer'
        # We had something going with this organization but we
        # couldn't close the deal and we don't think they will be a
        # customer to us in the foreseeable future.
        #    organization.relation = MoveToGo::Relation::BeenInTouch
        # else
        #    organization.relation = MoveToGo::Relation::NoRelation
        # end

        return organization
    end

    # The following properties are set on the person by default:
    #
    # LIME Go field                                LIME Pro field label
    # person.first_name                            Name
    # person.last_name                             Name
    # person.direct_phone_number                   BusinessTelephoneNumber
    # person.mobile_phone_number                   MobileTelephoneNumber
    # person.position                              JobTitle
    # person.email                                 PrimaryEmailAddress
    def to_person(person, row)
        ## Here are some standard fields that are present
        # on a LIME Go person that might be represented as custom
        # fields in Pro.
        # person.first_name = row["firstname"]
        # person.last_name = row["lastname"]

        # person.direct_phone_number = row['phone']
        # person.mobile_phone_number = row['cellphone']
        # person.email = row['email']
        # person.position = row['position']

        #####################################################################
        ## Tags.
        # Set tags for the person
        # person.set_tag("VIP")

        #####################################################################
        ## Checkbox fields.
        # Checkbox fields are normally translated into tags
        # Xmas card field is a checkbox in Easy

        # if row['Xmascard'] == "1"
        #     person.set_tag("Xmas card")
        # end

        #####################################################################
        ## Multioption fields or "Set"- fields.
        # Set fields are normally translated into multiple tags in LIME Go
        # interests is an example of a set field in LIME Pro.

        # if row['intrests']
        #     intrests = row['intrests'].split(';')
        #     intrests.each do |intrest|
        #         person.set_tag(intrest)
        #     end
        # end

        #####################################################################
        ## LIME Go custom fields.
        # This is how you populate a LIME Go custom field that was created in
        # the configure method.

        # person.set_custom_value("shoe_size", row['shoe size'])

        return person
    end

    # The following properties are set on the person by default:
    #
    # LIME Go field                                LIME Pro field NAME
    # deal.name                                    name
    # deal.description                             wonlostreason
    # deal.value                                   businessvalue
    def to_deal(deal, row)
        
        # deal.name = row['name'] 
        ## Here are some standard fields that are present
        # on a LIME Go deal and are usually represented
        # as custom fields in Pro.

        # deal.order_date = row['orderdate']

        # Deal.value should be integer
        # The currency used in Pro should match the one used in Go

        # deal.value = row['value']

        # should be between 0 - 100
        # remove everything that is not an intiger

        # deal.probability = row['probability'].gsub(/[^\d]/,"").to_i unless row['probability'].nil?

        # Sets the deal's status to the value of the Pro field. This
        # assumes that the status is already created in LIME Go. To
        # create statuses during import add them to the settings
        # during configure.

        # if !row['businessstatus'].nil? && !row['businessstatus'].empty?
        #     deal.status = row['status']
        # end

        #####################################################################
        ## Tags.
        # Set tags for the deal

        # deal.set_tag("productname")

        return deal
    end

    # Reads a row from the History table 
    # and ads custom fields to the move-to-go history.

    # NOTE!!! You should customize this method to include
    # and transform the fields you want to import to LIME Go.
    # The method includes examples of different types of
    # fields and how you should handle them.
    # Sometimes it's enough to uncomment some code and
    # change the row name but in most cases you need to
    # do some thinking of your own.
    def to_history(history, row)

        # history.text = row['text']

        # Set the history classification. The value must be a value from the
        # MoveToGo::HistoryClassification enum. If no classification is
        # set the history will get the default classification 'Comment'
        
        # case row['type']
        # when 'Sales call' 
        #   history.classification = MoveToGo::HistoryClassification::SalesCall
        # when 'Customer Visit'
        # history.classification = MoveToGo::historyClassification::ClientVisit
        # when 'No answer'
        #   history.classification = MoveToGo::HistoryClassification::TriedToReach
        # else
        #   history.classification = MoveToGo::HistoryClassification::Comment
        # end
        
        return history
    end

    
    def configure(rootmodel)
        #####################################################################
        ## LIME Go custom fields.
        # This is how you add a custom field in LIME Go.
        # Custom fields can be added to organization, deal and person.
        # Valid types are :String and :Link. If no type is specified
        # :String is used as default.

        # rootmodel.settings.with_person  do |person|
        #     person.set_custom_field( { :integration_id => 'shoe_size', :title => 'Shoe size', :type => :String} )
        # end

        # rootmodel.settings.with_deal do |deal|
            # assessment is default DealState::NoEndState
        #     deal.add_status( {:label => '1. Kvalificering' })
        #     deal.add_status( {:label => '2. Deal closed', :assessment => MoveToGo::DealState::PositiveEndState })
        #     deal.add_status( {:label => '4. Deal lost', :assessment => MoveToGo::DealState::NegativeEndState })
        # end
    end

    # HOOKS
    #
    # Sometimes you need to add exra information to the rootmodel, this can be done
    # with hooks, below is an example of an organization hook that adds a comment to
    # an organization if a field has a specific value
    #def organization_hook(row, organization, rootmodel)
    #    if not row['fieldname'].empty?
    #        comment = MoveToGo::Comment.new
    #        comment.text = row['fieldname']
    #        comment.organization = organization
    #        comment.created_by = rootmodel.migrator_coworker
    #        rootmodel.add_comment(comment)
    #    end
    #end

end

