const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);
const db = admin.firestore()

const request = require('request-promise');
const _ = require('lodash');

exports.pullFromGitHub = functions.https.onRequest(async (req, response) => {
    if (req.body.access_token && req.body.uid) {
        const headers = {
            'User-Agent': 'DevMatch',
            'Authorization': 'token ' + req.body.access_token,
            'Content-Type': 'application/json'
        }
        const stats = {}

        let user = await request('https://api.github.com/user', {
            headers
        })
        user = JSON.parse(user)

        stats.picture = user.avatar_url
        stats.username = user.login
        stats.followers = user.followers
        stats.following = user.following
        stats.repos = user.public_repos
        stats.gists = user.public_gists

        let repos = await request('https://api.github.com/user/repos?per_page=100', {
            headers
        })
        repos = JSON.parse(repos)

        stats.stars = _.sumBy(repos, (o) => o.stargazers_count)

        let langMap = {}

        await Promise.all(repos.map(async (repo) => {
            let languages = await request(repo.languages_url, {
                headers
            })
            languages = JSON.parse(languages)

            _.keys(languages).map((lang) => {
                if (langMap[lang] === undefined) {
                    langMap[lang] = languages[lang]
                } else {
                    langMap[lang] += languages[lang]
                }
            })
        }))

        stats.languages = langMap

        await db.collection('user').doc(req.body.uid).set(stats)

        response.send(stats)
    }
})