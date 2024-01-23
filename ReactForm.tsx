import React, { useState } from "react";

interface FormData {
  textInput: string;
  textareaInput: string;
  selectInput: string;
  radioInput: string;
  checkboxInput1: boolean;
  checkboxInput2: boolean;
}

export function Form() {
  const [formData, setFormData] = useState<FormData>({
    textInput: "",
    textareaInput: "",
    selectInput: "",
    radioInput: "radioOption1",
    checkboxInput1: false,
    checkboxInput2: false,
  });

  const selectOptions = {
    option1: "Option 1",
    option2: "Option 2",
    option3: "Option 3",
  };

  const handleChange = (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement | HTMLSelectElement>) => {
    const { name, value, type } = e.target;
    const checked = type === "checkbox" ? (e.target as HTMLInputElement).checked : undefined;

    setFormData((prevData) => ({
      ...prevData,
      [name]: type === "checkbox" ? !!checked : value,
    }));
  };

  const handleSubmit = (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();

    // Add validation logic here before performing any action with the form data
    // console.log("Form Data:", formData);
  };

  return (
    <form onSubmit={handleSubmit}>
      {/* Text Input */}
      <label htmlFor="textInput">
        Text Input:
        <input
          type="text"
          id="textInput"
          name="textInput"
          value={formData.textInput}
          onChange={handleChange}
          aria-label="Text Input"
        />
      </label>

      <br />

      {/* Textarea Input */}
      <label htmlFor="textareaInput">
        Textarea Input:
        <textarea
          id="textareaInput"
          name="textareaInput"
          value={formData.textareaInput}
          onChange={handleChange}
          aria-label="Textarea Input"
        />
      </label>

      <br />

      {/* Select Dropdown */}
      <label htmlFor="selectInput">
        Select Dropdown:
        <select
          id="selectInput"
          name="selectInput"
          value={formData.selectInput}
          onChange={handleChange}
          aria-label="Select Dropdown"
        >
          <option value="">Select an option</option>
          {Object.entries(selectOptions).map(([key, option]) => (
            <option key={key} value={key}>
              {option}
            </option>
          ))}
        </select>
      </label>

      <br />

      {/* Radio Buttons */}
      <div>
        {Object.entries(selectOptions).map(([key, option]) => (
          <label key={key} htmlFor={`radio${key}`}>
            <input
              type="radio"
              id={`radio${key}`}
              name="radioInput"
              value={key}
              checked={formData.radioInput === key}
              onChange={handleChange}
              aria-label={`Select ${option}`}
            />
            {`Select ${option}`}
          </label>
        ))}
      </div>

      <br />

      {/* Checkboxes */}
      <div>
        {Object.entries(selectOptions).map(([key, option]) => (
          <label key={key} htmlFor={`checkbox${key}`}>
            <input
              type="checkbox"
              id={`checkbox${key}`}
              name={`checkbox${key}`}
              checked={!!formData[`checkbox${key}` as keyof FormData]} // Ensure boolean value
              onChange={handleChange}
              aria-label={`Toggle ${option}`}
            />
            {`Toggle ${option}`}
          </label>
        ))}
      </div>

      <br />

      {/* Submit Button */}
      <button type="submit">Submit</button>
    </form>
  );
}
