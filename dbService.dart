import { initializeApp } from 'firebase/app'
import {
    getFirestore, collection, onSnapshot,
    addDoc, doc, query, where
}from 'firebase/firestore'

const firebaseConfig = {
    apiKey: "AIzaSyAJrMkGJjp3nwScsXfzuAGIImtYeltV_08",
    authDomain:"project-646cb.firebaseapp.com",
    projectID: "project-646cb",
    storageBucket: "project-646cb.appspot.com",
    messagingSenderId:"631362710531",
    appId: "1:631362710531:web:9d0f0a9a051ff1163ab236"
}

initializeApp(firebaseConfig)

const db= getFirestore()

const term = collection(db, 'termékek')

const q = query(term, where())