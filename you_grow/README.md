Case Study: Super.com

### Assumptions/Notes
For exercise:
- Beth is able to sell in multiple countries, making the country dimension relevant
Overall:
- did not complete `schema.ymls` as codegen package would be used to save time in true set-up

### Question 1
See this dbt project.
- First, the data was staged as seen in `1_staging` folder.
- Next, `core` tables were built (core folder... later modified based on Beth's growing needs)
- Finally, the `monthly_top_metrics` mart was created to satisfy the KPI requirements.
- In anticipation of next steps, the `monthly_metrics_sliced` query for slicing metrics by various segments was added to the analyses folder for version control and consistency.

### Question 2
See this dbt project.
- Given these customer focused KPIs, intermediate transformations were created to establish cohorts, first order attributes and life time tracking.
    See: `int_richtree__customer__first_order_cohort` and `int_richtree__customer__lifetime`
- This led to the core `customers` mart being retooled beyond base information to be a one-stop shop for customer related core fields.
- Last, given the requirements for slicing, a sliced metrics mart was created (`monthly_customer_cohort_metrics`).
- In anticipation of also needing top level stats, the `monthly_cohort_top_level` query was added to the analyses folder.

- I set up the model to be able to sliced in a visualization or reporting tool using additional functions in either Excel or a tool like Tableau.

### Question 3
I assume the subscriptions data would come in as a separate raw table. 
- This would be staged appropriately 1:1 with basic renaming and transforms as needed.
- From there, given subscriptions would be further information on an order (or order line depending on what level a subscription can be made at), relevant fields would be added to the core `order_lines` mart.
- The customers mart may be updated to add subscription information at the customer level as well.


### Recommended Next Steps:
- build dbt model(s) to specifically serve BI
- build out subscription marts to track monthly recurring revenue
- recommend connceting with supplier to understand shipping time to establish service level and order aging KPIs