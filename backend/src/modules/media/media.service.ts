import { Injectable, BadRequestException } from '@nestjs/common';
import * as admin from 'firebase-admin';
import { v4 as uuidv4 } from 'uuid';
import * as path from 'path';
import serviceAccount from '../../firebase-service-account.json';

// Initialize Firebase Admin SDK once
if (!admin.apps.length) {
  admin.initializeApp({
    credential: admin.credential.cert(serviceAccount as admin.ServiceAccount),
    storageBucket: 'ebzim-storage.firebasestorage.app',
  });
}

export interface CloudinaryResponse {
  url: string;
  public_id: string;
  resource_type: string;
  format: string;
}

interface UploadedFile {
  mimetype: string;
  originalname: string;
  buffer: Buffer;
  size: number;
}

@Injectable()
export class MediaService {
  async uploadImage(
    file: UploadedFile,
    folder = 'ebzim/uploads',
  ): Promise<CloudinaryResponse> {
    if (
      !/^(image\/(jpeg|png|gif|webp)|video\/(mp4|webm)|application\/pdf)$/.test(
        file.mimetype,
      )
    ) {
      throw new BadRequestException(
        'Invalid file type. Only jpeg, png, gif, webp imagery, mp4, webm videos, or pdf documents are allowed.',
      );
    }

    try {
      const bucket = admin.storage().bucket();
      const ext = file.originalname ? path.extname(file.originalname) : '';
      const fileName = `${folder}/${uuidv4()}${ext}`;

      const fileRef = bucket.file(fileName);

      await fileRef.save(file.buffer as Buffer, {
        metadata: {
          contentType: file.mimetype,
        },
      });

      // Make the file publicly accessible
      await fileRef.makePublic();

      const publicUrl = `https://storage.googleapis.com/${bucket.name}/${fileName}`;

      return {
        url: publicUrl,
        public_id: fileName,
        resource_type: file.mimetype.startsWith('image/') ? 'image' : 'raw',
        format: ext.replace('.', ''),
      };
    } catch (error: unknown) {
      const message = error instanceof Error ? error.message : 'Unknown error';
      console.error('[Firebase Storage Upload Error]', error);
      throw new BadRequestException(`فشل رفع الملف: ${message}`);
    }
  }

  async deleteMedia(publicId: string): Promise<{ result: string }> {
    try {
      const bucket = admin.storage().bucket();
      await bucket.file(publicId).delete();
      return { result: 'ok' };
    } catch (error: unknown) {
      console.error('[Firebase Storage Delete Error]', error);
      return { result: 'not_found' };
    }
  }
}
