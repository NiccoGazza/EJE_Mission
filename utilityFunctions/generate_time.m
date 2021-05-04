function time_vector = generate_time(begin_date, end_date)
    number_of_days = caldays(between(begin_date, end_date, 'days'));
    date = begin_date;
    
    for i=1:number_of_days
        time_vector(i, 1) = year(date);
        time_vector(i, 2) = month(date);
        time_vector(i, 3) = day(date);
        date = date + 1;
    end    
end