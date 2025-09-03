CREATE TABLE IF NOT EXISTS Cuisines (
	Cuisine     VARCHAR(256) PRIMARY KEY
);

CREATE TABLE IF NOT EXISTS Menu (
	Item        VARCHAR(256) PRIMARY KEY,
	Price       Numeric(10, 2) NOT NULL CHECK (Price > 0),
	Cuisine     VARCHAR(256) NOT NULL REFERENCES Cuisines(Cuisine) ON UPDATE CASCADE,
    UNIQUE (Item, Cuisine)
);

CREATE TABLE IF NOT EXISTS Registrations (
	Phone            CHAR(8) PRIMARY KEY CHECK (Phone ~ '^[0-9]{8}$'),
	FirstName        Text NOT NULL,
	LastName         Text NOT NULL,
    Date             DATE NOT NULL,
    Time             TIME NOT NULL
);

CREATE TABLE IF NOT EXISTS Staff (
	Staff             CHAR(8),
	Name              VARCHAR(256) NOT NULL,
    Cuisine           VARCHAR(256) NOT NULL REFERENCES Cuisines(Cuisine) ON UPDATE CASCADE,
	PRIMARY KEY (Staff, Cuisine)
);

CREATE TABLE IF NOT EXISTS Orders (
	"Order"           CHAR(11) PRIMARY KEY,
	Payment           CHAR(4) NOT NULL CHECK (Payment IN ('card','cash')),
	Card              VARCHAR(19),
	CardType          VARCHAR(256),
	TotalPrice        Numeric(10,2) NOT NULL CHECK (TotalPrice > 0),
	Phone             CHAR(8) REFERENCES Registrations(Phone) ON UPDATE CASCADE,
	CHECK (
    (payment='card' AND card IS NOT NULL AND CardType IS NOT NULL)
    OR
    (payment='cash' AND card IS NULL AND CardType IS NULL)
    ),
    CHECK (Card IS NULL OR Card ~ '^[0-9]{4}(-[0-9]{4}){3}$'),
    CHECK (Phone ~ '^[0-9]{8}$')
);

CREATE TABLE IF NOT EXISTS OrderLines (
    "Order"          CHAR(11) NOT NULL REFERENCES Orders("Order") ON UPDATE CASCADE,
    LineID           INT NOT NULL, 
    Item             VARCHAR(256) NOT NULL,
    Cuisine          VARCHAR(256) NOT NULL,
    Staff            Char(8) NOT NULL,
    Quantity         INT NOT NULL,
    PRIMARY KEY ("Order", LineID),
    UNIQUE ("Order", Item, Staff), 
    FOREIGN KEY (Item, Cuisine)  REFERENCES Menu(Item, Cuisine)   ON UPDATE CASCADE,
    FOREIGN KEY (Staff, Cuisine) REFERENCES Staff(Staff, Cuisine) ON UPDATE CASCADE
)
