
const Person = 'CNIC,Fname,Lname,DOB,Gender,Address,PhoneNum,City,Province';
const Admin = 'a_id,CNIC';
const Constituency = 'City_Division,City,Province';
const National = 'Code,City_Div';
const N_Candidate = 'Cand_id,CNIC,N_code,Party_id,Year';
const Parties = 'party_id,Pname,Symbol,Agenda,Num_Candidates';
const Registered_Voters = 'Voter_id,CNIC,Prov_id,N_code,Year';
const P_Candidate = 'Cand_id,CNIC,Party_id,Const_id';
const Provincial = 'Const_id,Assembly,Code,City_Div';
const Votes_Casted_Provincial = 'CNIC,Prov_id,Cand_id,Year';
const Votes_Casted_National = 'CNIC,N_code,Cand_id,Year';

const tables = {
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

module.exports= tables,
                Person,
                Admin,
                Constituency,
                National,
                N_Candidate,
                P_Candidate,
                Parties,
                Registered_Voters,
                Provincial,
                Votes_Casted_National,
                Votes_Casted_Provincial