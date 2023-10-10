-- Create the batch table with the run_date column
CREATE TABLE batch (
    batch_id SERIAL PRIMARY KEY,
    pipeline_name VARCHAR(255),
    date_to DATE,
    date_from DATE,
    run_date DATE DEFAULT CURRENT_DATE, -- Added run_date column with default value
    comment TEXT
);

-- Create the cleaned_data table
CREATE TABLE cleaned_data (
    batch_id INT,
    msgid INT,
    msg TEXT,
    PRIMARY KEY (batch_id, msgid)
);

-- Create the preped_data table
CREATE TABLE preped_data (
    batch_id INT,
    msgid INT,
    diagnosis TEXT,
    diagnosis_comment TEXT,
    addendum TEXT,
    micro TEXT,
    gross TEXT,
    filtered_message TEXT,
    part_of_report TEXT,
    PRIMARY KEY (batch_id, msgid),
    FOREIGN KEY (batch_id) REFERENCES batch(batch_id)
);

-- Create the prediction_table
CREATE TABLE prediction_table (
    batch_id INT,
    msgid INT,
    predicted_label INT,
    model_score DECIMAL(10, 2),
    model_id INT,
    PRIMARY KEY (batch_id, msgid),
    FOREIGN KEY (batch_id) REFERENCES batch(batch_id)
);

-- Create the labels table
CREATE TABLE labels (
    model_id INT,
    label INT,
    label_name VARCHAR(255),
    PRIMARY KEY (model_id, label)
);
