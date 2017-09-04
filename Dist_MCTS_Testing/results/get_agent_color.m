function [ color ] = get_agent_color( type )
    type = mod(type,7);
    if type == 0
        color = 'k';
        else if type == 1
            color = 'b';
        else if type == 2
                color = 'r';
            else if type == 3
                    color = 'g';
                else if type == 4
                        color = 'c';
                    else if type == 5
                            color = 'y';
                    	else if type == 6
                                color = 'm';
                            end
                        end
                    end
                end
            end
        end
    end
end

