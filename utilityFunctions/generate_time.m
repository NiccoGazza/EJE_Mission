%generate_time ha l'obiettivo di generare un vettore di date per ogni
%giorno compreso tra begin_date ed end_date; essendo le componenti del 
%vettore anno, mese e giorno di una datetime, possono essere utilizzate
%come input alla funzione planet_and_elements_and_sv per ricavare
%parametri orbitali/vettore di stato di un pianeta.

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