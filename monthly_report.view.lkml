view: monthly_report {
  derived_table: {
    sql:

    select
      g.name as group_name,
      coalesce(count(user.id),0) as user ,
      coalesce(count(s.user_id),0) as loggedin,
      coalesce(count(shared.user_id),0) as shared

      from (select company_id, id from user where status=0) as user

      left outer join (
        select distinct user_id from pbdata.analytics_data_user_adoption_sign_in
        where

        {% condition company_id%} company_id {% endcondition %} AND
        {% condition date_range%} `date` {% endcondition %} AND

        signed_in = 1 ) as s
        on s.user_id = user.id

      left outer join (
        select distinct user_id from  pbdata.analytics_data_user_adoption_sign_in
        where

        {% condition company_id%} company_id {%endcondition %} AND
        {% condition date_range%} `date` {% endcondition %} AND

        shared=1 ) as shared
        on shared.user_id = user.id
      inner join
      usergroup as ug
      on ug. user_id = user.id
      inner join
      `group` as g
      on ug.group_id = g.id
      where

       {% condition company_id%} g.company_id {%endcondition %}
      group by g.name;
        ;;
  }


  # # Define your dimensions and measures here, like this:
  dimension: group_name {
    label: "group name"
    type: string
    sql: ${TABLE}.group_name ;;

  }
  dimension: user {
    label: "registered users"
    type: number
    sql: ${TABLE}.user ;;
  }
  dimension: loggedin_user {
    label: "signed in users"
    type: number
    sql: ${TABLE}.loggedin;;
  }
  dimension: shared_user {
    label: "shared users"
    type: number
    sql: ${TABLE}.shared ;;
  }
  filter: company_id {
    type: number
    label: "FILTER company_id"
  }

  filter: date_range {
    type: date
    label: "FILTER date_range"
  }
}
