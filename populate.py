import requests
import json

apiURL = 'http://localhost:3000/insert'


Person = 'CNIC,Fname,Lname,DOB,Gender,Address,PhoneNum,City,Province'
Admin = 'a_id,CNIC'
Constituency = 'City_Division,City,Province'
National = 'Code,City_Div'
N_Candidate = 'Cand_id,CNIC,N_code,Party_id,Year'
Parties = 'party_id,Pname,Symbol,Agenda,Num_Candidates'
Registered_Voters = 'Voter_id,CNIC,Prov_id,N_code,Year'
P_Candidate = 'Cand_id,CNIC,Party_id,Const_id,Year'
Provincial = 'Const_id,Assembly,Code,City_Div'
Votes_Casted_Provincial = 'CNIC,Prov_id,Cand_id,Year'
Votes_Casted_National = 'CNIC,N_code,Cand_id,Year'

tables = {
    'Person': Person.split(','),
    'Admin': Admin.split(','),
    'Constituency': Constituency.split(','),
    'National': National.split(','),
    'N_Candidate': N_Candidate.split(','),
    'Parties': Parties.split(','),
    'Registered_Voters': Registered_Voters.split(','),
    'P_Candidate': P_Candidate.split(','),
    'Provincial': Provincial.split(','),
    'Votes_Casted_Provincial': Votes_Casted_Provincial.split(','),
    'Votes_Casted_National': Votes_Casted_National.split(','),
}

def parseObject(tableName,record):
    attrList = tables[tableName]
    record = record.split(',')
    data = {}
    for x in range(len(attrList)):
        if('\n' in record[x]):
            temp = record[x].strip()
            data[attrList[x]] = temp
            # print(temp)
        else:
            data[attrList[x]] = record[x]
    return data

def insert(fileName):
    tableName = fileName.split(".")[0]
    # attrList = tables[]
    with open(fileName) as file:
        for i,line in enumerate(file):
            if not i == 0:
                # print(line)
                data = parseObject(tableName,line)
                data['tableName'] = tableName
                # print(data)
                res = requests.post(apiURL,data)
                # print(res.json())
                print(res)
                # data = {}
                # print()


# insert("Person.txt")
# insert("Constituency.txt")

if __name__ == "__main__":
    filename = input("Enter filename to read\n")
    insert(filename)
