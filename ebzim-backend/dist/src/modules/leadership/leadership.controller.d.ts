import { LeadershipService } from './leadership.service';
import { CreateLeaderDto, UpdateLeaderDto } from './dto/create-leader.dto';
export declare class LeadershipController {
    private readonly leadershipService;
    constructor(leadershipService: LeadershipService);
    findAll(): Promise<(import("mongoose").Document<unknown, {}, import("./schemas/leader.schema").LeaderDocument, {}, import("mongoose").DefaultSchemaOptions> & import("./schemas/leader.schema").Leader & import("mongoose").Document<import("mongoose").Types.ObjectId, any, any, Record<string, any>, {}> & Required<{
        _id: import("mongoose").Types.ObjectId;
    }> & {
        __v: number;
    } & {
        id: string;
    })[]>;
    create(dto: CreateLeaderDto): Promise<import("mongoose").Document<unknown, {}, import("./schemas/leader.schema").LeaderDocument, {}, import("mongoose").DefaultSchemaOptions> & import("./schemas/leader.schema").Leader & import("mongoose").Document<import("mongoose").Types.ObjectId, any, any, Record<string, any>, {}> & Required<{
        _id: import("mongoose").Types.ObjectId;
    }> & {
        __v: number;
    } & {
        id: string;
    }>;
    update(id: string, dto: UpdateLeaderDto): Promise<(import("mongoose").Document<unknown, {}, import("./schemas/leader.schema").LeaderDocument, {}, import("mongoose").DefaultSchemaOptions> & import("./schemas/leader.schema").Leader & import("mongoose").Document<import("mongoose").Types.ObjectId, any, any, Record<string, any>, {}> & Required<{
        _id: import("mongoose").Types.ObjectId;
    }> & {
        __v: number;
    } & {
        id: string;
    }) | null>;
    delete(id: string): Promise<(import("mongoose").Document<unknown, {}, import("./schemas/leader.schema").LeaderDocument, {}, import("mongoose").DefaultSchemaOptions> & import("./schemas/leader.schema").Leader & import("mongoose").Document<import("mongoose").Types.ObjectId, any, any, Record<string, any>, {}> & Required<{
        _id: import("mongoose").Types.ObjectId;
    }> & {
        __v: number;
    } & {
        id: string;
    }) | null>;
}
