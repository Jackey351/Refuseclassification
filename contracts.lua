local comp = function(a,b)
    return a.score > b.score
end

function postScore(account_id,account_name,score)
    -- 以下两行用于清空区块链
    -- write_list = {public_data = {}}
    -- chainhelper:write_chain()
    local i = 0
    read_list = { public_data = { scores = true }}
    chainhelper:read_chain()
    if  public_data.scores and next(public_data.scores) ~= nil then
        for key, value in pairs(public_data.scores) do
            if value.account_id == account_id then
                value.score = score
    	        i = 1
    	        break
    	    end
        end
        if i == 0 then
            table.insert(public_data.scores, {account_id = account_id ,account_name = account_name ,score = score})
        end
    else
        public_data.scores = {}
        table.insert(public_data.scores, {account_id = account_id , account_name = account_name , score = score})
    end
    write_list = {public_data = {}}
    chainhelper:write_chain()
    
    read_list = { public_data = { scores = true }}
    chainhelper:read_chain()
    table.sort(public_data.scores, comp)
    if  public_data.scores and next(public_data.scores) ~= nil then
        local topRank = {}
        local me = {}
        local response ={}
        for key, value in pairs(public_data.scores) do
            if key <=3 then
                 table.insert(topRank, value)
            end
        end
        for key, value in pairs(public_data.scores) do
            if value.account_id == account_id then
                table.insert(me, { myScore = value.score })
    	        break
    	    end
        end
        for key, value in pairs(public_data.scores) do
            if value.account_id == account_id then
                table.insert(me, { myRank = key })
                break
            end
        end
        table.insert(response, topRank)
        table.insert(response, me)
        chainhelper:log(cjson.encode(response))
    end
end