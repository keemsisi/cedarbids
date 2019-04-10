\c postgres
DROP DATABASE cedarbids;
create database cedarbids;
\c cedarbids

-- this can used to map the registered company
DROP TABLE  IF EXISTS contractor;
CREATE TABLE contractor(
	contractor_id VARCHAR(36) not null PRIMARY KEY UNIQUE,
	username varchar(36) not null unique,
	password varchar(2500) not null unique,
	profile_image text null,
	login boolean null,
	last_login timestamp not null,
	last_logout timestamp not null
);


DROP TABLE  IF EXISTS general_information_section;
CREATE TABLE IF NOT EXISTS general_information_section(
	id varchar(36) not null primary key,
	company_name varchar(250) not null,
        company_addresses JSON NULL default null,
        po_box_address varchar(250) NULL default null,
        mailing_address varchar(2500) null,
        telephones JSON NULL default null,
        email_addresses varchar(250) not null,
        website_address varchar(250) not null,
        contact_person varchar(250) not NULL default null,
        ownership_and_parent_company varchar(2500) NULL default null,
        name_and_address_of_subsidiary JSON NULL default null,
        nature_of_business varchar(250) NULL default null,
        type_of_business varchar(250) NULL default null,
        year_of_established int NULL  default null,
      	number_of_employees int default 0,
        vat_number_or_taxid varchar(250) NULL default null,
        licence_no_or_state_where_registered varchar(250),
        technical_documents_available_in varchar(50) default null,
        working_languages varchar(50),
	contractor_id VARCHAR(36) not null,

	CONSTRAINT gis_con
   	FOREIGN KEY (contractor_id)
    	REFERENCES contractor(contractor_id) 
    	ON DELETE CASCADE
    	ON UPDATE CASCADE
);


DROP TABLE  IF EXISTS finalcial_information_section;
CREATE TABLE IF NOT EXISTS finalcial_information_section(
	id varchar(36) primary key not null unique,
	year_USD JSON NULL default null, -- holds year and amount symbol
	--- holds the directory to the finacial report files 
	financian_report_files_dir varchar(2500) not null,
	annual_val_of_export_sales_lst_Yrs JSON default null,
	bank_name varchar(250) not null,
        swift_bic_address varchar(250) default null,
        bank_account_number varchar(10)  not null ,
        account_name varchar(250) NOT NULL,
	contractor_id VARCHAR(36) not null ,

CONSTRAINT con_fis
    FOREIGN KEY (contractor_id) 
    REFERENCES contractor(contractor_id) 
    ON DELETE CASCADE
    ON UPDATE CASCADE
);


DROP TABLE  IF EXISTS experiences_section;
CREATE TABLE IF NOT EXISTS experiences_section(
	id varchar(36) primary key not null unique,
	experiences JSON NULL default null,
	contractor_id VARCHAR(36) not null ,

CONSTRAINT con_es
    FOREIGN KEY (contractor_id) 
    REFERENCES contractor(contractor_id) 
    ON DELETE CASCADE
    ON UPDATE CASCADE
);


DROP TABLE  IF EXISTS others_section;
CREATE TABLE IF NOT EXISTS others_section(
	id varchar(36) primary key not null unique,
	questionOne boolean default null,
	copy_of_environmental_policy_dir varchar(2500) null default null,
	question_two boolean default null,
	membershipList JSON NULL default null,
	certifications_dir varchar(2500) null default null,
	contractor_id VARCHAR(36) not null,
	

CONSTRAINT con_os
    FOREIGN KEY (contractor_id) 
    REFERENCES contractor(contractor_id) 
    ON DELETE CASCADE
    ON UPDATE CASCADE
);


DROP TABLE  IF EXISTS tech_capability;
CREATE TABLE IF NOT EXISTS tech_capability(
      id varchar(36) primary key not null unique,
-- Quality Assurance Certification General Civil Aviation Authority Certification
      tech_capability_files_dir varchar(250) not null,
      interantional_offices Text  null,
      services text not null,
      contractor_id VARCHAR(36) not null,



CONSTRAINT con_tc
    FOREIGN KEY (contractor_id) 
    REFERENCES contractor(contractor_id) 
    ON DELETE CASCADE
    ON UPDATE CASCADE

);







DROP TABLE  IF EXISTS Admin;
CREATE TABLE Admin
(
    id VARCHAR(36) NOT NULL PRIMARY KEY,
    role varchar(50) not null, -- this role can be master_admin of sub_admin
    username VARCHAR (250) NOT NULL,
    password VARCHAR (250) NOT NULL,
    profile_image text NULL,
    login boolean default false,
    last_login timestamp default null,
    last_logout timestamp default null
);



DROP TABLE IF EXISTS contractor_cookies;
CREATE TABLE contractor_cookies 
-- can be used to save the cookies of each contractor so that their activities can
-- ...be monitored on the system
(
    cookies_id VARCHAR(36) NOT NULL PRIMARY KEY, 
    cookie_value VARCHAR(2500) not null,
    contractor_id VARCHAR(36) not null,
    

-- this can help the contractor use their former history to navigate through the 
-- system 
CONSTRAINT con_cc
    FOREIGN KEY (contractor_id) 
    REFERENCES contractor(contractor_id) 
    ON DELETE CASCADE
    ON UPDATE CASCADE

);

-- Stores the generated authentication Oject-hash
DROP TABLE IF EXISTS DevAuthKey;
CREATE TABLE AuthKeys(
    dev_id VARCHAR(100) NOT NULL PRIMARY KEY,
    dev_suername VARCHAR(250) NULL , 
    dev_password VARCHAR(250) NULL,
    dev_apikey VARCHAR(36) NULL
);

DROP TABLE IF EXISTS created_bidding;
CREATE TABLE IF NOT EXISTS created_bidding(
    bidding_id VARCHAR(36) NOT NULL PRIMARY KEY UNIQUE,
    contractor_id varchar(36) not null, 


-- the creator of the bid
    CONSTRAINT con_bidding
    FOREIGN KEY (contractor_id) 
    REFERENCES contractor(contractor_id) 
    ON DELETE CASCADE
    ON UPDATE CASCADE
);


DROP TABLE IF EXISTS tender;
CREATE TABLE tender(

    tender_id VARCHAR(36) NOT NULL PRIMARY KEY , 
    tender_submission_date DATE NOT NULL ,
    tender_file_dir TEXT NOT NULL,
    contractor_id varchar(36) not null, 
    bidding_id varchar(36) not null , 

    CONSTRAINT con_tender 
    FOREIGN KEY (contractor_id) 
    REFERENCES contractor(contractor_id) 
    ON UPDATE CASCADE
    ON DELETE CASCADE,

    CONSTRAINT  con_tendering_1
    FOREIGN KEY (bidding_id)
    REFERENCES created_bidding(bidding_id) 
    ON UPDATE CASCADE
    ON DELETE CASCADE
);


DROP TABLE IF EXISTS applied_bidders;
CREATE TABLE IF NOT EXISTS applied_bidders(
	applied_contractor_id varchar(36) not null PRIMARY KEY UNIQUE,
	bidding_id varchar(36) not null,
	tender_id varchar(36) not null,

CONSTRAINT con_appliedbidders
    	FOREIGN KEY (applied_contractor_id)
    	REFERENCES contractor(contractor_id)
	ON DELETE CASCADE
	ON UPDATE CASCADE,

CONSTRAINT con_appliedbidders_1
    	FOREIGN KEY (tender_id)
    	REFERENCES tender(tender_id)
	ON DELETE CASCADE
	ON UPDATE CASCADE,

CONSTRAINT con_appliedbidders_2
    	FOREIGN KEY (bidding_id)
    	REFERENCES created_bidding(bidding_id)
	ON DELETE CASCADE
	ON UPDATE CASCADE
);



--- THIS SHOULD BE RESOLVED LATER
DROP TABLE if EXISTS contractor_document_upload;
CREATE TABLE contractor_document_upload
(
    id INT  NOT NULL auto_increment PRIMARY KEY,
-- Holds the directory to the contractor folder
    document_dir_link Varchar(250) NOT NULL,
    contractor_id  varchar(36) NOT NULL , 

CONSTRAINT con_doc_Upload 
    FOREIGN KEY fk_doc_upload(contractor_id) 
    REFERENCES contractor(contractor_id) 
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

--- THIS SHOULD BE RESOLVED LATER


DROP TABLE IF EXISTS Message;
create table Message( 
	id Varchar(36) not null primary key,
	date_recieved DATE ,
	message_recieved TEXT, 
	sender_id Varchar(36) not null,
	receiver_id varchar(36) not null,
--
CONSTRAINT con_messages 
    FOREIGN KEY (receiver_id) 
    REFERENCES contractor(contractor_id) 
    ON UPDATE CASCADE
    ON DELETE CASCADE,

--
CONSTRAINT con_messages_1
    FOREIGN KEY (sender_id) 
    REFERENCES contractor(contractor_id) 
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

--LATER

DROP TABLE IF EXISTS services;
create table services(
	id varchar(36) not null primary key , 

-- hold the services that offer delimitted with commas 
	service_offered text not null,
	contractor_id varchar(36) not null , 

-- the contractor with the services 
	constraint con_services 
    FOREIGN KEY fk_services(contractor_id) 
    REFERENCES contractor(contractor_id) 
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

--LATER


DROP TABLE IF EXISTS shortlisted_applied_bidders;
create table shortlisted_applied_bidders(
	id SERIAL not null primary key UNIQUE,
	bidding_id varchar(36) not null,

-- This will hold the shortlisted ContratorId as series of jeson strng obj.
	shortlisted_contractor_ids TEXT not null,

constraint con_sab 
foreign key (bidding_id)
REFERENCES created_bidding(bidding_id) 
ON UPDATE CASCADE
ON DELETE CASCADE
);


DROP TABLE IF EXISTS bidding_score;
create table bidding_score(
	id SERIAL not null  primary key,
	bidding_score DECIMAL not null,
	bidding_id varchar(36) not null,
	contractor_id varchar(36) not null,

	constraint con_bs
	foreign key (contractor_id)
	REFERENCES contractor(contractor_id)
	on delete cascade 
	on update cascade,

constraint con_bs_1
	foreign key (bidding_id)
	REFERENCES created_bidding(bidding_id) 
	on delete cascade 
	on update cascade
);



-- the bidding category
DROP TABLE IF EXISTS category;
CREATE TABLE IF NOT EXISTS category(
	category_id varchar(40) NOT NULL PRIMARY KEY UNIQUE ,
	category_name VARCHAR(250) NOT NULL UNIQUE,
	category_description VARCHAR(2500) NULL
);

DROP TABLE IF EXISTS books;
CREATE TABLE IF NOT EXISTS books(
	id varchar(40) NOT NULL PRIMARY KEY UNIQUE ,
	bidding_id varchar(40) NOT NULL UNIQUE ,
	biddind_start_date TIMESTAMP WITH TIME ZONE NOT NULL,
	bidding_end_date TIMESTAMP WITH TIME ZONE NOT NULL,
	bidding_description TEXT NOT NULL,
	bidding_document_dir VARCHAR(2500) NOT NULL,
	contractor_id varchar(36) not null,
	category_id varchar(36) not null,

-- the creator of the bid
CONSTRAINT con_bidding
FOREIGN KEY (contractor_id) 
REFERENCES contractor(contractor_id) 
ON DELETE CASCADE
ON UPDATE CASCADE,

CONSTRAINT con_category
FOREIGN KEY (category_id) 
REFERENCES category(category_id)
ON UPDATE CASCADE
ON DELETE CASCADE
);

DROP TABLE IF EXISTS educational_trade_equipment_and_supplies;
CREATE TABLE IF NOT EXISTS 
	educational_trade_equipment_and_supplies (LIKE books) ;


DROP TABLE IF EXISTS training_education_consulting;
CREATE TABLE IF NOT EXISTS 
	training_education_consulting (LIKE books) ;

DROP TABLE IF EXISTS science_equipment_supplies_and_laboratory_services;
CREATE TABLE IF NOT EXISTS 
	science_equipment_supplies_and_laboratory_services (LIKE books) ;


DROP TABLE IF EXISTS theatrical_staging_supplies_services;
CREATE TABLE IF NOT EXISTS  
	theatrical_staging_supplies_services (LIKE books) ;

DROP TABLE IF EXISTS musical_instruments_supplies_services;
CREATE TABLE IF NOT EXISTS  
	musical_instruments_supplies_services (LIKE books) ;


DROP TABLE IF EXISTS library_services_supplies;
CREATE TABLE IF NOT EXISTS  
	library_services_supplies (LIKE books) ;

DROP TABLE IF EXISTS sports_equipment_services;
CREATE TABLE IF NOT EXISTS  
	sports_equipment_services (LIKE books) ;



-- Telecommications 
DROP TABLE IF EXISTS networkcabling_fibreopticsproducts_services;
CREATE TABLE IF NOT EXISTS 
	networkcabling_fibreopticsproducts_services (LIKE books) ;


DROP TABLE IF EXISTS telecom_equipment_supplies_services;
CREATE TABLE IF NOT EXISTS 
	telecom_equipment_supplies_services (LIKE books) ;

DROP TABLE IF EXISTS tele_consulting_services;
CREATE TABLE IF NOT EXISTS 
	tele_consulting_services (LIKE books) ;






-- Electronics/ Appliances
DROP TABLE IF EXISTS general_appliances;
CREATE TABLE IF NOT EXISTS 
	general_appliances (LIKE books) ;


DROP TABLE IF EXISTS audio_visual_electronics_services;
CREATE TABLE IF NOT EXISTS
	audio_visual_electronics_services (LIKE books) ;

-- Medical/ Surgical
DROP TABLE IF EXISTS medical_equipment_instruments;
CREATE TABLE IF NOT EXISTS 
	medical_equipment_instruments (LIKE books) ;

DROP TABLE IF EXISTS dental_equipment_services;
CREATE TABLE IF NOT EXISTS 
	dental_equipment_services (LIKE books) ;

DROP TABLE IF EXISTS social_programs_services;
CREATE TABLE IF NOT EXISTS 
	social_programs_services (LIKE books) ;

DROP TABLE IF EXISTS pharmaceuticals_services;
CREATE TABLE IF NOT EXISTS 
	pharmaceuticals_services (LIKE books) ;

DROP TABLE IF EXISTS medical_supplies;
CREATE TABLE IF NOT EXISTS 
	medical_supplies (LIKE books) ;
  
DROP TABLE IF EXISTS medical_consulting_services;
CREATE TABLE IF NOT EXISTS 
	medical_consulting_services (LIKE books) ;


DROP TABLE IF EXISTS unclassified_bidding;
CREATE TABLE IF NOT EXISTS 
	unclassified_bidding (LIKE books) ;

DROP TABLE IF EXISTS office_supplies;
CREATE TABLE IF NOT EXISTS 
	office_supplies (LIKE books) ;

DROP TABLE IF EXISTS general_supplies;
CREATE TABLE IF NOT EXISTS 
	general_supplies (LIKE books) ;

DROP TABLE IF EXISTS office_equipment_services_excluding_computers;
CREATE TABLE IF NOT EXISTS 
	office_equipment_services_excluding_computers (LIKE books) ;


DROP TABLE IF EXISTS furniture_other_specialty_wares;
CREATE TABLE IF NOT EXISTS 
	furniture_other_specialty_wares (LIKE books) ;


-- Construction
DROP TABLE IF EXISTS roads_sewer_watermain;
CREATE TABLE IF NOT EXISTS 
	roads_sewer_watermain (LIKE books) ;


DROP TABLE IF EXISTS construction_project_manager;
CREATE TABLE IF NOT EXISTS 
	construction_project_manager (LIKE books) ;


DROP TABLE IF EXISTS building_projects_renovation_demolition_projects;
CREATE TABLE IF NOT EXISTS 
	building_projects_renovation_demolition_projects (LIKE books) ;

DROP TABLE IF EXISTS heating_plumbing_mechanical_supplies_services;
CREATE TABLE IF NOT EXISTS 
	heating_plumbing_mechanical_supplies_services (LIKE books) ;


DROP TABLE IF EXISTS landscaping_grounds_maintenance_supplies;
CREATE TABLE IF NOT EXISTS 
	landscaping_grounds_maintenance_supplies (LIKE books) ;


DROP TABLE IF EXISTS winter_maintenance_supplies;
CREATE TABLE IF NOT EXISTS 
	winter_maintenance_supplies (LIKE books) ;

DROP TABLE IF EXISTS roofing_supplies_services;
CREATE TABLE IF NOT EXISTS 
	roofing_supplies_services (LIKE books) ;

DROP TABLE IF EXISTS painting_supplies_services;
CREATE TABLE IF NOT EXISTS 
	painting_supplies_services (LIKE books) ;

DROP TABLE IF EXISTS electrical_supplies_services;
CREATE TABLE IF NOT EXISTS 
	electrical_supplies_services (LIKE books) ;

DROP TABLE IF EXISTS water_treatment_plants;
CREATE TABLE IF NOT EXISTS 
	water_treatment_plants (LIKE books) ;


DROP TABLE IF EXISTS construction_hardware;
CREATE TABLE IF NOT EXISTS 
	construction_hardware (LIKE books) ;

DROP TABLE IF EXISTS parks_recreational_facilities;
CREATE TABLE IF NOT EXISTS 
	parks_recreational_facilities (LIKE books) ;

DROP TABLE IF EXISTS bridges_elevated_highways_tunnels_subways_railroads;
CREATE TABLE IF NOT EXISTS 
	bridges_elevated_highways_tunnels_subways_railroads (LIKE books) ;


DROP TABLE IF EXISTS construction_materials_equipment;
CREATE TABLE IF NOT EXISTS 
	construction_materials_equipment (LIKE books) ;

-- =>Computers
DROP TABLE IF EXISTS it_consulting;
CREATE TABLE IF NOT EXISTS
	 it_consulting (LIKE books) ;

DROP TABLE IF EXISTS it_consulting;
CREATE TABLE IF NOT EXISTS
	 computer_services (LIKE books) ;

DROP TABLE IF EXISTS computer_hardware;
CREATE TABLE IF NOT EXISTS 
	computer_hardware (LIKE books) ;


-- Energy/ Fuel/ Chemical (1245)
DROP TABLE IF EXISTS nuclear_energy_industry_services_nuclear_waste_management;
CREATE TABLE IF NOT EXISTS
	 nuclear_energy_industry_services_nuclear_waste_management (LIKE books) ;


DROP TABLE IF EXISTS chemical_products_services;
CREATE TABLE IF NOT EXISTS 
	chemical_products_services (LIKE books) ;

DROP TABLE IF EXISTS renewable_energy;
CREATE TABLE IF NOT EXISTS 
	renewable_energy (LIKE books) ;

DROP TABLE IF EXISTS energy_products_services_management;
CREATE TABLE IF NOT EXISTS 
	energy_products_services_management (LIKE books) ;

DROP TABLE IF EXISTS fuel_products_services;
CREATE TABLE IF NOT EXISTS 
	fuel_products_services (LIKE books) ;


-- Business Services/ Supplies

DROP TABLE IF EXISTS printing_services_graphics_imaging_desktop_design_equipment;
CREATE TABLE IF NOT EXISTS 
	printing_services_graphics_imaging_desktop_design_equipment (LIKE books) ;

DROP TABLE IF EXISTS security_services_supplies;
CREATE TABLE IF NOT EXISTS 
	security_services_supplies (LIKE books) ;

DROP TABLE IF EXISTS signage_billboards;
CREATE TABLE IF NOT EXISTS 
	signage_billboards (LIKE books) ; 

DROP TABLE IF EXISTS shipping_courier_transportation_services_storage_services;
CREATE TABLE IF NOT EXISTS 
	shipping_courier_transportation_services_storage_services (LIKE books) ; 

DROP TABLE IF EXISTS pest_control_animal_services_supplies;
CREATE TABLE IF NOT EXISTS 
	pest_control_animal_services_supplies (LIKE books) ; 

DROP TABLE IF EXISTS recycling_goods_and_waste_removal_management_services
CREATE TABLE IF NOT EXISTS 
	recycling_goods_and_waste_removal_management_services(LIKE books) ; 

DROP TABLE IF EXISTS safety_equipment_ervices_supplies;
CREATE TABLE IF NOT EXISTS 
	safety_equipment_ervices_supplies (LIKE books) ; 

DROP TABLE IF EXISTS hospitality_conference_special_events_travel_services;
CREATE TABLE IF NOT EXISTS
	 hospitality_conference_special_events_travel_services (LIKE books) ; 

DROP TABLE IF EXISTS marketing_promotional_advertising_services;
CREATE TABLE IF NOT EXISTS 
	marketing_promotional_advertising_services (LIKE books) ; 

DROP TABLE IF EXISTS clothing_textiles;
CREATE TABLE IF NOT EXISTS 
	clothing_textiles (LIKE books) ; 

DROP TABLE IF EXISTS nursery_plants;
CREATE TABLE IF NOT EXISTS 
	nursery_plants (LIKE books) ; 

DROP TABLE IF EXISTS sale_of_surplus_goods;
CREATE TABLE IF NOT EXISTS 
	sale_of_surplus_goods (LIKE books) ; 

DROP TABLE IF EXISTS janitorial_cleaning_services_equipment_and_supplies;
CREATE TABLE IF NOT EXISTS 
	janitorial_cleaning_services_equipment_and_supplies (LIKE books) ; 


-- Agricultural/ Forestry/ Mining
DROP TABLE IF EXISTS mining_products_services_consulting;
CREATE TABLE IF NOT EXISTS 
	mining_products_services_consulting (LIKE books) ;

DROP TABLE IF EXISTS agricultural_products_services;
CREATE TABLE IF NOT EXISTS 
	agricultural_products_services (LIKE books) ;


DROP TABLE IF EXISTS forestry_products_services;
CREATE TABLE IF NOT EXISTS 
	forestry_products_services (LIKE books) ;

DROP TABLE IF EXISTS agricultural_equipment;
CREATE TABLE IF NOT EXISTS 
	agricultural_equipment (LIKE books) ;


-- Automotive/ Industrial (4767)
DROP TABLE IF EXISTS industrial_vehicles_equipment;
CREATE TABLE IF NOT EXISTS 
	industrial_vehicles_equipment ( LIKE books );

DROP TABLE IF EXISTS aviation_supplies_services;
CREATE TABLE IF NOT EXISTS 
	aviation_supplies_services( LIKE books ) ;

DROP TABLE IF EXISTS recreational_vehicles_and_Services;
CREATE TABLE IF NOT EXISTS 
	recreational_vehicles_and_Services( LIKE books ) ;

DROP TABLE IF EXISTS heavy_equipment_vehicles;
CREATE TABLE IF NOT EXISTS
	 heavy_equipment_vehicles ( LIKE books ) ;

DROP TABLE IF EXISTS tools_supplies_parts;
CREATE TABLE IF NOT EXISTS
	 tools_supplies_parts ( LIKE books ) ;

DROP TABLE IF EXISTS passenger_vehicles;
CREATE TABLE IF NOT EXISTS
	 passenger_vehicles ( LIKE books ) ;


DROP TABLE IF EXISTS automotive_services;
CREATE TABLE IF NOT EXISTS
	 automotive_services ( LIKE books ) ;


-- =>Food Industry (324)
DROP TABLE IF EXISTS food_services_supplies_equipment;
CREATE TABLE IF NOT EXISTS
	 food_services_supplies_equipment ( LIKE books ) ;


DROP TABLE IF EXISTS food_products;
CREATE TABLE IF NOT EXISTS
	 food_products ( LIKE books ) ;

DROP TABLE IF EXISTS paper_stationery;
CREATE TABLE IF NOT EXISTS
	 paper_stationery ( LIKE books ) ;

DROP TABLE IF EXISTS general_supplies;
CREATE TABLE IF NOT EXISTS
	 general_supplies ( LIKE books ) ;

DROP TABLE IF EXISTS office_equipment_services_excluding_computers;
CREATE TABLE IF NOT EXISTS
	 office_equipment_services_excluding_computers ( LIKE books ) ;

DROP TABLE IF EXISTS furniture_other_specialty_wares;
CREATE TABLE IF NOT EXISTS
	 furniture_other_specialty_wares ( LIKE books ) ;



