const express = require('express');
const bodyParser = require('body-parser');
const app = express();
const mysql = require('mysql');
const squel = require('squel');
const path = require('path');

const db_name = "Election Record System";

app.use(bodyParser.urlencoded({extended: true}));

sqlDB = mysql.createConnection({
		host: "localhost",
		user: "root",
		password: "mysql",
		database: db_name
	})
console.log("connected to SQL DB");



const runQuery = async function(q){
	return new Promise (async (resolve,reject) => {
		sqlDB.query(q, (err,result) =>{
			if(err){
				reject(err); 
			}
			else{
				resolve(result);
			}
		})
	})
}

insertValue = async function(table, data){
	q = squel.insert()
			.into(table)
			.setFields(data)
			.toString();
	return new Promise (async (resolve, reject) => {
		sqlDB.query(q, (err, result) => {
			if(err){
				if(err.code == "ER_DUP_ENTRY"){
					resolve("DUPLICATE - NOT ENTERED")
				} else 
					reject(err);
			}
			else{
				console.log(result);
				resolve(result)
			}
		});
	});
}
delValue = async function(table, attr, val){
	q = squel.delete()
			.from(table)
			.where(attr + " = " + "'" + val + "'")
			.toString();

	return new Promise (async (resolve, reject) => {
		sqlDB.query(q, (err, result) => {
			if(err){
				reject(err);
			}
			else{
				console.log(result);
				resolve(result)
			}
		});
	});
}
updateTable = async function(tableName, data, matchAttr, matchVal){
	q = squel.update()
			.table(tableName)
			.setFields(data)
			.where(matchAttr + " = " + "'" + matchVal + "'")
			.toString();

	return new Promise (async (resolve, reject) => {
		sqlDB.query(q, (err, result) => {
			if(err){
				reject(err);
			}
			else{
				console.log(result);
				resolve(result)
			}
		});
	});
}

function formatDate(date) {
    var d = new Date(date),
        month = '' + (d.getMonth() + 1),
        day = '' + d.getDate(),
        year = d.getFullYear();

    if (month.length < 2) month = '0' + month;
    if (day.length < 2) day = '0' + day;

    return [day,month,year].join('-');
}


function json2table(json, classes) {
	var cols = Object.keys(json[0]);
	
	var headerRow = '';
	var bodyRows = '';
	
	classes = classes || '';
  
	function capitalizeFirstLetter(string) {
	  return string.charAt(0).toUpperCase() + string.slice(1);
	}
  
	cols.map(function(col) {
	  headerRow += '<th>' + capitalizeFirstLetter(col) + '</th>';
	});
  
	json.map(function(row) {
	  bodyRows += '<tr>';
  
	  cols.map(function(colName) {
		  if(colName == 'DOB'){
			bodyRows += '<td>' + formatDate(row[colName]) + '</td>';			
		  }
		  else{
			  bodyRows += '<td>' + row[colName] + '</td>';
		  }
	  })
  
	  bodyRows += '</tr>';
	});
  
	return '<table class="' +
		   classes +
		   '"><thead><tr>' +
		   headerRow +
		   '</tr></thead><tbody>' +
		   bodyRows +
		   '</tbody></table>';
  }
  


app.post('/query', (req,res) => {
	runQuery("SET GLOBAL sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));").then(results => console.log(results));
	let q = req.body.query;
	const goBack = `<form action="/query.html">
    <input type="submit" value="Go Back" />
</form>`
	if(req.body.par){
		q = q.replace(new RegExp('par', 'g'),req.body.par);
		// console.log(q);
	}
	else if(req.body.par0 && req.body.par1){
		q = q.replace(new RegExp('par0', 'g'),req.body.par0);
		q = q.replace(new RegExp('par1', 'g'),req.body.par1);
		// console.log(q);
	}

	runQuery(q).then(results => {
		html = `<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css" integrity="sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO" crossorigin="anonymous">`
		html+= `<link rel="stylesheet" href="style.css">`
		html+= `<link rel="stylesheet" href="table.css">`
		html += "<h2>"+results.length+" Records found</h2>" + json2table(results,'table table-hover table-mc-light-blue');
		res.send(html + goBack);
	})
	.catch(err => {
		console.log("Error: " + err);
		res.end("<h1>" + err + "</h1>" + goBack)
	})
})

app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname+'/forms/home.html'));
});

app.get('/insert.html' , (req, res) => {
    res.sendFile(path.join(__dirname+'/forms/insert.html'));
});

app.get('/style.css' , (req, res) => {
    res.sendFile(path.join(__dirname+'/forms/style.css'));
});

app.get('/bg.jpg' , (req, res) => {
    res.sendFile(path.join(__dirname+'/forms/bg.jpg'));
});

app.get('/home.html' , (req, res) => {
    res.sendFile(path.join(__dirname+'/forms/home.html'));
});

app.get('/q.html' , (req, res) => {
    res.sendFile(path.join(__dirname+'/forms/query1.html'));
});

app.get('/query.html' , (req, res) => {
	
    res.sendFile(path.join(__dirname+'/forms/query.html'));
});

app.get('/delete.html' , (req, res) => {
    res.sendFile(path.join(__dirname+'/forms/delete.html'));
});

app.get('/update.html' , (req, res) => {
    res.sendFile(path.join(__dirname+'/forms/update.html'));
});

(async () => {
	app.listen(3000, () => {
		console.log('listening on 3000');
	})

	app.post('/insert', (async (req, res) => {
		tableName = req.body.tableName
		console.log(tableName)
		data = {}
		Object.entries(req.body).forEach(	
			([key, value]) => {
				if(key != "tableName"){
					data[key] = value;
				}
			}
		)
		try {
			ans = await insertValue(tableName, data)
			res.send(ans);
			res.redirect('/');
		} catch(err) {
			console.log(err);
			res.redirect('/');
		}
	}));

	app.post('/update', (async (req, res)=>{
		tableName = req.body.tableName;
		id_attr = req.body.attr
		id_val = req.body.id
		data = {}
		Object.entries(req.body).forEach(	
			([key, value]) => {
				if(key != "tableName" && key != "id" && value != "" && key != "attr"){
					data[key] = value;
				}
			}
		)
		try{
			ans = await updateTable(tableName, data, id_attr, id_val);
			console.log(ans);
			res.send(ans);
		} catch(err) {
			console.log(err);
			res.redirect('/');
		}
	}));

	app.post('/delete', (async(req, res) => {
		tableName = req.body.tableName
		id_attr = req.body.attr;
		id_val = req.body.id
		console.log(tableName,id_attr,id_val);
		try{
			ans = await delValue(tableName, id_attr, id_val)
			console.log(ans);
			res.send(ans);
		} catch(err) {
			console.log(err);
			res.send(err);
		}
		res.redirect('/');
	}));
})();


