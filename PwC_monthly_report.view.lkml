view: pwc_monthly_report {
  derived_table: {
    sql:
      SELECT COALESCE(us.shared,0) as shared,
          COALESCE(ul.loggedin,0) as loggedin,
          COALESCE(totalshares.totalshares,0) as totalshares,
          COALESCE(fs.facebook_shares,0) as facebookshares,
          COALESCE(ts.twitter_shares,0) as twittershares,
          COALESCE(ls.linkedin_shares,0) as linkedinshares,
          COALESCE(fi.fbint,0) as facebookinteractions,
          COALESCE(ti.twint,0) as twitterinteractions,
          COALESCE(li.lkint,0) as linkedininteractions

      FROM company AS c
      LEFT JOIN (
                SELECT company_id, count(distinct user_id) AS shared
                FROM analytics_data_post_user
                WHERE
                {% condition company_id %} company_id {% endcondition %} AND
                {% condition date_range %} `date` {% endcondition %} AND
                (twitter_share<>0 or facebook_share<>0 or linkedin_share<>0)
                GROUP BY company_id
                ) AS us ON c.id = us.company_id

      LEFT JOIN (
                SELECT company_id, count(distinct user_id) AS loggedin
                FROM pbdata.analytics_data_user_adoption_sign_in
                WHERE
                {% condition company_id %} company_id {% endcondition %} AND
                {% condition date_range %} `date` {% endcondition %} AND
                signed_in = 1
                GROUP BY company_id
                ) AS ul ON c.id = ul.company_id

      LEFT JOIN (
                SELECT company_id, sum( facebook_share + twitter_share + linkedin_share ) AS totalshares
                FROM analytics_data_post_user
                WHERE
                {% condition date_range %} `date` {% endcondition %} AND
                {% condition company_id %} company_id {% endcondition %}
                GROUP BY company_id
                ) AS totalshares ON totalshares.company_id = c.id


      LEFT JOIN (
                SELECT company_id, sum(facebook_share) AS facebook_shares
                FROM analytics_data_post_user
                WHERE
                {% condition company_id %} company_id {% endcondition %} AND
                {% condition date_range%} `date` {% endcondition %} AND
                facebook_share<>0
                GROUP BY company_id
                ) AS fs ON fs.company_id = c.id

      LEFT JOIN (
                SELECT company_id, sum(twitter_share) AS twitter_shares
                FROM analytics_data_post_user
                WHERE
                {% condition company_id %} company_id {% endcondition %} AND
                {% condition date_range %} `date` {% endcondition %} AND
                twitter_share<>0
                GROUP BY company_id
                ) AS ts ON ts.company_id = c.id


      LEFT JOIN (
                SELECT company_id, sum(linkedin_share) AS linkedin_shares
                FROM analytics_data_post_user
                WHERE
                {% condition company_id %} company_id {% endcondition %} AND
                {% condition date_range %} `date` {% endcondition %} AND
                linkedin_share<>0
                GROUP BY company_id
                ) AS ls ON ls.company_id = c.id


      LEFT JOIN (
                SELECT company_id, sum( facebook_clickthrough+ facebook_comment+ facebook_impression+ facebook_like+ facebook_reshare+ facebook_share ) AS fbint
                FROM pbdata.analytics_data_posts
                WHERE
                {% condition company_id %} company_id {% endcondition %} AND
                {% condition date_range %} `date` {% endcondition %}
                GROUP BY company_id
                ) as fi ON fi.company_id = c.id


      LEFT JOIN (
                SELECT company_id, sum(linkedin_clickthrough+ linkedin_comment+ linkedin_impression+ linkedin_like+ linkedin_share) AS lkint
                FROM pbdata.analytics_data_posts
                WHERE
                {% condition company_id %} company_id {% endcondition %} AND
                {% condition date_range %} `date` {% endcondition %}
                GROUP BY company_id
                ) as li ON li.company_id = c.id


      LEFT JOIN (
                SELECT company_id, sum(twitter_clickthrough+ twitter_favorite+ twitter_impression+ twitter_reply+ twitter_retweet+ twitter_share) AS twint
                FROM pbdata.analytics_data_posts
                WHERE
                {% condition company_id %} company_id {% endcondition %} AND
                {% condition date_range %} `date` {% endcondition %}
                GROUP BY company_id
                ) as ti ON ti.company_id = c.id

      inner join company
      on c.id= company.id
      WHERE

      {% condition company_id %} c.id {% endcondition %}

              ;;
  }


  # # Define your dimensions and measures here, like this:
  dimension: shared  {
    label: "monthly user shares"
    description: "number of users who have shared in the month"
    type: number
    sql: ${TABLE}.shared ;;
  }
  dimension: loggedin {
    label: "monthly user signed in"
    description: "number of users who logged in for the month"
    type: number
    sql: ${TABLE}.loggedin ;;
  }
  dimension: totalshares {
    label: "monthly total shares"
    description: "total shares for the month"
    type: number
    sql: ${TABLE}.totalshares ;;
  }
  dimension: facebookshares {
    label: "monthly facebook shares"
    description: "number of shares for the month to facebook"
    type: number
    sql: ${TABLE}.facebookshares ;;
  }
  dimension: twittershares {
    label: "monthly twitter shares"
    description: "number of shares for the month to twitter"
    type: number
    sql: ${TABLE}.twittershares ;;
  }
  dimension: linkedinshares {
    label: "monthly linkedin shares"
    description: "number of shares for the month to linkedin"
    type: number
    sql: ${TABLE}.linkedinshares ;;
  }
  dimension: facebookinteractions{
    label: "facebook interactions"
    description: "total interactions on facebook for the month"
    type: number
    sql: ${TABLE}.facebookinteractions ;;
  }
  dimension: twitterinteractions {
    label: "twitter interactions"
    description: "total interactions on twitter for the month"
    type: number
    sql: ${TABLE}.twitterinteractions ;;
  }
  dimension: linkedininteractions  {
    label: "linkedin interactions"
    description: "total interactions on linkedin for the month"
    type: number
    sql: ${TABLE}.linkedininteractions ;;
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
