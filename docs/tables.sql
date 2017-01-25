CREATE TABLE company (
    id         CHAR(10)     NOT NULL PRIMARY KEY,
    account    CHAR(20)     NOT NULL,
    account_my VARCHAR(20)  NOT NULL,
    name       VARCHAR(100) NOT NULL,
    notes      VARCHAR(300) NOT NULL DEFAULT ''
);

CREATE TABLE transaction (
    id         INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    company_id CHAR(10)         NOT NULL,
    date       DATE             NOT NULL,
    date_paid  DATE,
    amount     INT(10) UNSIGNED NOT NULL,

    PRIMARY KEY (id),
    FOREIGN KEY (company_id) REFERENCES company(id)
);
