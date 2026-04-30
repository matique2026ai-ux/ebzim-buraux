import { Injectable, BadRequestException } from '@nestjs/common';
import { createClient } from '@supabase/supabase-js';
import { v4 as uuidv4 } from 'uuid';
import * as path from 'path';

const SUPABASE_URL = 'https://kuoezhgkfxctcxecodak.supabase.co';
const SUPABASE_SERVICE_KEY =
  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imt1b2V6aGdrZnhjdGN4ZWNvZGFrIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc3NzQwNTYxMywiZXhwIjoyMDkyOTgxNjEzfQ.Xl-LDkOENbprpuWC2v-hI28XIKgekdym6q4vdqv1nrs';
const BUCKET_NAME = 'ebzim';

const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_KEY);

export interface MediaResponse {
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
    folder = 'uploads',
  ): Promise<MediaResponse> {
    if (
      !/^(image\/(jpeg|png|gif|webp)|video\/(mp4|webm)|application\/pdf)$/.test(
        file.mimetype,
      )
    ) {
      throw new BadRequestException(
        'نوع الملف غير مسموح. الأنواع المقبولة: jpeg, png, gif, webp, mp4, webm, pdf.',
      );
    }

    const ext = file.originalname ? path.extname(file.originalname) : '';
    const fileName = `${folder}/${uuidv4()}${ext}`;

    const { error } = await supabase.storage
      .from(BUCKET_NAME)
      .upload(fileName, file.buffer, {
        contentType: file.mimetype,
        upsert: false,
      });

    if (error) {
      console.error('[Supabase Upload Error]', error);
      throw new BadRequestException(`فشل رفع الملف: ${error.message}`);
    }

    const { data } = supabase.storage.from(BUCKET_NAME).getPublicUrl(fileName);

    return {
      url: data.publicUrl,
      public_id: fileName,
      resource_type: file.mimetype.startsWith('image/') ? 'image' : 'raw',
      format: ext.replace('.', ''),
    };
  }

  async deleteMedia(publicId: string): Promise<{ result: string }> {
    const { error } = await supabase.storage
      .from(BUCKET_NAME)
      .remove([publicId]);

    if (error) {
      console.error('[Supabase Delete Error]', error);
      return { result: 'not_found' };
    }
    return { result: 'ok' };
  }
}
