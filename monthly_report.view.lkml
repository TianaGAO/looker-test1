view: monthly_report {
  derived_table: {
    sql:

    select
      g.name as group_name,
      coalesce(count(user.id),0) as user ,
      coalesce(count(new_user.id),0) as new_user ,
      coalesce(count(s.user),0) as loggedin,
      coalesce(count(shared.user),0) as shared

      FROM
      usergroup AS ug
      INNER JOIN (
                 select id, name, company_id from  `group`
                where
                {% condition company_id %} company_id {% endcondition %}
                )  AS g

      ON ug.group_id = g.id
      LEFT OUTER JOIN
         (select company_id, id from user
          where
          {% condition company_id %} company_id {% endcondition %} AND
          status=0
          ) as user
      ON user.id = ug.user_id

      LEFT OUTER JOIN
         (select company_id, id from user
          where
          {% condition company_id %} company_id {% endcondition %} AND
          {% condition date_range %} `created` {% endcondition %} AND
          status=0
          ) as new_user
      ON new_user.id = ug.user_id

      left outer join (
        select distinct user_id  as user from user as u,pbdata.analytics_data_user_adoption_sign_in as s
        where

        {% condition company_id%} s.company_id {% endcondition %} AND
        {% condition date_range%} `date` {% endcondition %} AND
        u.status=0 AND
        u.id = s.user_id AND
         signed_in = 1 ) as s
        on s.user = ug.user_id

      left outer join (
        select distinct user_id as user from user u, pbdata.analytics_data_user_adoption_sign_in as s
        where

        {% condition company_id%} u.company_id {%endcondition %} AND
        {% condition date_range%} `date` {% endcondition %} AND
         u.status=0 AND
        u.id = s.user_id AND

        shared=1 ) as shared
        on shared.user = ug.user_id

      group by g.name;
        ;;
  }


  # # Define your dimensions and measures here, like this:
  dimension: group_name {
    label: "group name"
    type: string
    sql: ${TABLE}.group_name ;;

  }
  dimension: new_user {
    label: "new registered users"
    type: number
    sql: ${TABLE}.new_user ;;
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
