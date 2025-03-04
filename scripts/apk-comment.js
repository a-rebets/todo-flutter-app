const { UTApi } = require('uploadthing/server');
const fs = require('fs');
const path = require('path');
const { Octokit } = require('@octokit/rest');

const octokit = new Octokit({ auth: process.env.GITHUB_TOKEN });
const utapi = new UTApi({
    token: process.env.UPLOADTHING_TOKEN
});

async function uploadApk() {
    const apkPath = path.join(process.cwd(), 'build/app/outputs/flutter-apk/app-release.apk');
    const fileBuffer = fs.readFileSync(apkPath);
    const fileName = `app-release-PR${process.env.PR_NUMBER}-${process.env.RUN_ID}.apk`;
    const file = new File([fileBuffer], fileName, { 
        type: "application/vnd.android.package-archive" 
    });
    
    const results = await utapi.uploadFiles([file]);
    const uploadedFile = results[0].data;
    
    if (!uploadedFile) {
        throw new Error('Upload failed: No data returned from UploadThing');
    }
    
    return uploadedFile.ufsUrl;
}

async function main() {
    try {
        const apkUrl = await uploadApk();
        
        const comment = `## 📱 Preview APK Available
        
        A preview APK has been built for this PR.
        
        ### Build Information
        - PR: #${process.env.PR_NUMBER}
        - Commit: ${process.env.COMMIT_SHA}
        - Build: ${process.env.RUN_ID}
        
        ### Download
        [⬇️ Download APK](${apkUrl})
        `;
        
        await octokit.issues.createComment({
            owner: process.env.GITHUB_REPOSITORY.split('/')[0],
            repo: process.env.GITHUB_REPOSITORY.split('/')[1],
            issue_number: process.env.PR_NUMBER,
            body: comment
        });
    } catch (error) {
        console.error(`Failed to upload APK: ${error.message}`);
        process.exit(1);
    }
}

main(); 